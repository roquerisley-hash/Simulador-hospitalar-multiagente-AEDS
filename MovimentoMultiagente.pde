class MovimentoMultiagente {

  Coordenada[] intencoes;
  boolean[] podeMover;


  MovimentoMultiagente(int quantidadeMaxima) {

    intencoes = new Coordenada[quantidadeMaxima];
    podeMover = new boolean[quantidadeMaxima];
  }


  void movimentar(ListaEncadeada<Paciente> pacientes, char[][] mapa) {

    int quantidade = pacientes.count();

    for (int i = 0; i < quantidade; i++) {

      intencoes[i] = calcularIntencao(
        pacientes.get(i),
        pacientes,
        mapa
      );

      podeMover[i] = true;
    }


    for (int i = 0; i < quantidade; i++) {

      if (intencoes[i] != null) {

        for (int j = i + 1; j < quantidade; j++) {

          if (intencoes[j] != null &&
              intencoes[i].equals(intencoes[j])) {

            podeMover[j] = false;
          }
        }
      }
    }

    delay(250);
    
    for (int i = 0; i < quantidade; i++) {

      if (podeMover[i] && intencoes[i] != null) {

        pacientes.get(i).posicao = intencoes[i].copy();
      }
    }
  }


  Coordenada calcularIntencao(
    Paciente paciente,
    ListaEncadeada<Paciente> pacientes,
    char[][] mapa
  ) {

    if (paciente.destino == null) {
      return null;
    }


    WaveFront waveFront = new WaveFront();

    ListaEncadeada<Coordenada> caminho =
      waveFront.encontrarCaminho(
        mapa,
        paciente.posicao,
        paciente.destino
      );


    if (caminho.count() < 2) {
      return null;
    }


    Coordenada melhor = caminho.get(1);


    if (ocupada(
      melhor.linha,
      melhor.coluna,
      pacientes
    )) {

      return null;
    }


    return melhor.copy();
  }


  boolean ocupada(
    int linha,
    int coluna,
    ListaEncadeada<Paciente> pacientes
  ) {

    for (int i = 0; i < pacientes.count(); i++) {

      Paciente p = pacientes.get(i);

      if (p.posicao.linha == linha &&
          p.posicao.coluna == coluna) {

        return true;
      }
    }

    return false;
  }
}
