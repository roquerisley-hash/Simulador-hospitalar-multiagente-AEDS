final int LARGURA_JANELA = 800;
final int ALTURA_JANELA = 600;

final float mediaSpawnMillis = 5000;

float tempoProximoSpawn;
int idProximoPaciente;
int numNormal, numPreferencial;
ListaEncadeada<Paciente> pacientes;

Medico[] equipeMedica;
Paciente[] pacienteChamadoMedico;
boolean simulacaoPreparada;

String nomeArquivo = "";

void settings() {
  size(LARGURA_JANELA, ALTURA_JANELA);
}

void setup() {
  inicializarEstado();
  carregarAssets();
}

void carregarAssets() {
  inicializarCoresMapa();
  inicializarSpritesMapa();
  inicializarSpritesPacientes();
  listarMapas();
}

void inicializarEstado() {
  idProximoPaciente = 1;
  numNormal = 1;
  numPreferencial = 1;
  pacientes = new ListaEncadeada<>();
  tempoProximoSpawn = millisSimulacao() + gerarProximoSpawn();

  equipeMedica = null;
  pacienteChamadoMedico = null;
  simulacaoPreparada = false;

  tempoTotalPausado = 0;
}

void prepararSimulacao() {
  inicializarTotem();
  inicializarTriagem();

  equipeMedica = new Medico[qtdMedicos];
  pacienteChamadoMedico = new Paciente[qtdMedicos];

  for (int i = 0; i < qtdMedicos; i++) {
    equipeMedica[i] = new Medico(medicos[i]);
    pacienteChamadoMedico[i] = null;
  }

  tempoProximoSpawn = millisSimulacao() + gerarProximoSpawn();
  simulacaoPreparada = true;
}

void draw() {
  background(245);

  switch (estadoAtual) {
    case MENU_INICIAL:
      desenharMenuInicial();
      break;

    case SIMULACAO:
      if (!simulacaoPreparada && mensagemErro.equals("") && mapa != null) {
        prepararSimulacao();
      }

      if (simulacaoPreparada) {
        if (millisSimulacao() > tempoProximoSpawn) {
          gerarPaciente();
        }

        atualizarSimulacao();
      }

      desenharSimulacao();
      break;

    case MENU_PAUSA:
      desenharMenuPausa();
      break;
  }
}

void atualizarSimulacao() {
  atualizarTriagem();
  atualizarMedicos();
  atualizarAssentosMedicos();
  movimentarPacientes();
  processarChegadas();
  removerPacientesFinalizados();
}

void atualizarAssentosMedicos() {
  for (int i = 0; i < pacientes.count(); i++) {
    Paciente p = pacientes.get(i);

    if (p.estado == EstadoPaciente.INDO_ASSENTO_MEDICO &&
        (removedor == null || p.destino == null || !p.destino.equals(removedor)) &&
        !pacienteChamadoParaMedico(p) &&
        !pacienteEmConsulta(p) &&
        assentoDoPaciente(p) == -1) {

      int[][] distancias = calcularDistanciasAssentos(p);
      int idxAssento = reservarAssentoMaisProximo(distancias, p);

      if (idxAssento != -1) {
        p.destino = assentos[idxAssento].copy();
      }
    }
  }
}

boolean pacienteChamadoParaMedico(Paciente p) {
  for (int i = 0; i < qtdMedicos; i++) {
    if (pacienteChamadoMedico[i] == p) {
      return true;
    }
  }

  return false;
}

boolean pacienteEmConsulta(Paciente p) {
  for (int i = 0; i < qtdMedicos; i++) {
    if (equipeMedica[i].pacienteAtual == p) {
      return true;
    }
  }

  return false;
}

int assentoDoPaciente(Paciente p) {
  for (int i = 0; i < qtdAssentos; i++) {
    if (pacienteNoAssento[i] == p) {
      return i;
    }
  }

  return -1;
}

void atualizarMedicos() {
  for (int i = 0; i < qtdMedicos; i++) {
    Paciente finalizado = atendimentoMedico.atualizarConsulta(equipeMedica[i]);

    if (finalizado != null) {
      finalizado.destino = removedor.copy();
    }

    if (!equipeMedica[i].ocupado &&
        pacienteChamadoMedico[i] == null &&
        atendimentoMedico.temPaciente()) {

      Paciente proximo = atendimentoMedico.chamarProximoPaciente();

      if (proximo != null) {
        liberarAssento(proximo);

        Coordenada destino = celulaAdjacenteLivre(medicos[i]);

        if (destino != null) {
          pacienteChamadoMedico[i] = proximo;
          proximo.destino = destino.copy();
          proximo.estado = EstadoPaciente.INDO_MEDICO;
        }
      }
    }
  }
}

void movimentarPacientes() {
  int quantidade = pacientes.count();

  if (quantidade == 0) {
    return;
  }

  MovimentoMultiagente movimento = new MovimentoMultiagente(quantidade);
  movimento.movimentar(pacientes, mapa);
}

void processarChegadas() {

  for (int i = 0; i < pacientes.count(); i++) {

    Paciente p = pacientes.get(i);

    if (p.estado == EstadoPaciente.INDO_TOTEM &&
        p.posicao.equals(p.destino)) {

      p.estado = EstadoPaciente.TOTEM;
    }

    if (p.estado == EstadoPaciente.TOTEM &&
        p.posicao.equals(totem)) {

      int[][] distancias =
        calcularDistanciasAssentos(p);

      processarTotem(p, distancias);
    }

    if (p.estado == EstadoPaciente.INDO_ASSENTO_TRIAGEM &&
        p.posicao.equals(p.destino)) {

      if (p.ehPreferencial) {
        filaTriagemPreferencial.enfileirar(p);
      } else {
        filaTriagemNormal.enfileirar(p);
      }

      p.estado = EstadoPaciente.AGUARDANDO_TRIAGEM;
    }

    if (p.estado == EstadoPaciente.INDO_TRIAGEM &&
        p.posicao.equals(p.destino)) {

      for (int j = 0; j < qtdEnfermeiros; j++) {

        if (pacienteNaTriagem[j] == p) {

          iniciarAtendimentoTriagem(j, p);

          break;
        }
      }
    }

    if (p.estado == EstadoPaciente.INDO_ASSENTO_MEDICO &&
        p.posicao.equals(p.destino)) {

      String cor = manchester.classificar(p);
      p.classificacaoManchester = cor;

      atendimentoMedico.adicionarPaciente(p, cor);

      p.estado = EstadoPaciente.AGUARDANDO_MEDICO;
    }

    if (p.estado == EstadoPaciente.INDO_MEDICO &&
        p.posicao.equals(p.destino)) {

      for (int j = 0; j < qtdMedicos; j++) {

        if (pacienteChamadoMedico[j] == p) {

          atendimentoMedico.iniciarConsulta(
            equipeMedica[j],
            p
          );

          pacienteChamadoMedico[j] = null;

          break;
        }
      }
    }
  }
}

int[][] calcularDistanciasAssentos(Paciente p) {
  int[][] distancias = new int[numLinhas][numColunas];

  for (int i = 0; i < numLinhas; i++) {
    for (int j = 0; j < numColunas; j++) {
      distancias[i][j] = -1;
    }
  }

  WaveFront waveFront = new WaveFront();

  for (int i = 0; i < qtdAssentos; i++) {
    ListaEncadeada<Coordenada> caminho = waveFront.encontrarCaminho(
      mapa,
      p.posicao,
      assentos[i]
    );

    if (caminho.count() > 0) {
      distancias[assentos[i].linha][assentos[i].coluna] = caminho.count() - 1;
    }
  }

  return distancias;
}

void removerPacientesFinalizados() {
  int i = 0;

  while (i < pacientes.count()) {
    Paciente p = pacientes.get(i);

    if (removedor != null &&
        p.destino != null &&
        p.destino.equals(removedor) &&
        p.posicao.equals(removedor)) {

      removerPaciente(p);
    } else {
      i++;
    }
  }
}

void removerPaciente(Paciente paciente) {
  if (pacientes.cabeca == null) {
    return;
  }

  if (pacientes.cabeca.dado == paciente) {
    pacientes.cabeca = pacientes.cabeca.proximo;
    return;
  }

  No atual = pacientes.cabeca;

  while (atual.proximo != null) {
    if (atual.proximo.dado == paciente) {
      atual.proximo = atual.proximo.proximo;
      return;
    }

    atual = atual.proximo;
  }
}

void desenharSimulacao() {
  if (!mensagemErro.equals("")) {
    desenharErro();
    return;
  }

  desenharMapa();
  desenharPacientes();
}

void desenharPacientes() {
  int total = pacientes.count();
  for (int i = 0; i < total; i++) {
    pacientes.get(i).desenhar();
  }
}

void keyPressed() {
  if (key == ESC) {
    key = 0;

    if (estadoAtual == EstadoJogo.SIMULACAO) {
      pausarSimulacao();
    } else if (estadoAtual == EstadoJogo.MENU_PAUSA) {
      continuarSimulacao();
    }
  }
}

float gerarProximoSpawn() {
  float u = random(0, 1);
  float proximoSpawn = -mediaSpawnMillis * log(1 - u);
  return proximoSpawn;
}

void atualizarIDs(boolean ehPreferencial) {
  idProximoPaciente++;

  if (ehPreferencial) {
    numPreferencial++;
  } else {
    numNormal++;
  }
}

void gerarPaciente() {
  Paciente novoPaciente = new Paciente(idProximoPaciente, numNormal, numPreferencial, gerador, totem);

  atualizarIDs(novoPaciente.ehPreferencial);
  tempoProximoSpawn = millisSimulacao() + gerarProximoSpawn();

  pacientes.add(novoPaciente);
}
