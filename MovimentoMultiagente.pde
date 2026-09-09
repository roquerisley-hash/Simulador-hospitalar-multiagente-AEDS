class MovimentoMultiagente {

  WaveFront waveFront;

  MovimentoMultiagente() {

    waveFront =
      new WaveFront();
  }


  void movimentar(
    ListaEncadeada<Paciente> pacientes,
    char[][] mapa
  ) {

    int quantidade =
      pacientes.count();

    Coordenada[][] opcoes =
      new Coordenada[quantidade][4];

    Coordenada[] intencoes =
      new Coordenada[quantidade];

    Coordenada[] movimentos =
      new Coordenada[quantidade];


    for (int i = 0; i < quantidade; i++) {

      Paciente paciente =
        pacientes.get(i);

      opcoes[i] =
        calcularOpcoes(
          paciente,
          mapa
        );

      if (opcoes[i][0] != null) {

        intencoes[i] =
          opcoes[i][0].copy();
      }
    }


    for (int i = 0; i < quantidade; i++) {

      Paciente paciente =
        pacientes.get(i);

      if (intencoes[i] != null &&
          !posicaoOcupada(
            intencoes[i],
            paciente,
            pacientes,
            quantidade
          ) &&
          !posicaoReservada(
            intencoes[i],
            movimentos,
            i
          )) {

        movimentos[i] =
          intencoes[i].copy();

      } else {

        for (int j = 1; j < 4; j++) {

          if (opcoes[i][j] != null &&
              !posicaoOcupada(
                opcoes[i][j],
                paciente,
                pacientes,
                quantidade
              ) &&
              !posicaoReservada(
                opcoes[i][j],
                movimentos,
                i
              )) {

            movimentos[i] =
              opcoes[i][j].copy();

            break;
          }
        }
      }
    }


    for (int i = 0; i < quantidade; i++) {

      if (movimentos[i] != null) {

        Paciente paciente =
          pacientes.get(i);

        paciente.posicao =
          movimentos[i].copy();
      }
    }
  }


  Coordenada[] calcularOpcoes(
    Paciente paciente,
    char[][] mapa
  ) {

    Coordenada[] opcoes =
      new Coordenada[4];

    if (paciente == null ||
        paciente.posicao == null ||
        paciente.destino == null) {

      return opcoes;
    }

    if (paciente.posicao.equals(
        paciente.destino)) {

      return opcoes;
    }

    int[][] distancia =
      waveFront.calcularDistancias(
        mapa,
        paciente.destino
      );

    Coordenada[] vizinhos =
      new Coordenada[4];

    vizinhos[0] =
      new Coordenada(
        paciente.posicao.linha - 1,
        paciente.posicao.coluna
      );

    vizinhos[1] =
      new Coordenada(
        paciente.posicao.linha + 1,
        paciente.posicao.coluna
      );

    vizinhos[2] =
      new Coordenada(
        paciente.posicao.linha,
        paciente.posicao.coluna - 1
      );

    vizinhos[3] =
      new Coordenada(
        paciente.posicao.linha,
        paciente.posicao.coluna + 1
      );

    int[] valores =
      new int[4];

    for (int i = 0; i < 4; i++) {

      valores[i] = 999999;

      if (waveFront.coordenadaValida(
          mapa,
          vizinhos[i])) {

        int valor =
          distancia[
            vizinhos[i].linha
          ][
            vizinhos[i].coluna
          ];

        if (valor >= 0) {

          valores[i] =
            valor;
        }
      }
    }


    for (int i = 0; i < 4; i++) {

      int menorIndice = -1;
      int menorValor = 999999;

      for (int j = 0; j < 4; j++) {

        if (valores[j] < menorValor) {

          menorValor =
            valores[j];

          menorIndice =
            j;
        }
      }

      if (menorIndice != -1) {

        opcoes[i] =
          vizinhos[menorIndice].copy();

        valores[menorIndice] =
          999999;
      }
    }

    return opcoes;
  }


  boolean posicaoOcupada(
    Coordenada posicao,
    Paciente pacienteAtual,
    ListaEncadeada<Paciente> pacientes,
    int quantidade
  ) {

    for (int i = 0; i < quantidade; i++) {

      Paciente outro =
        pacientes.get(i);

      if (outro != pacienteAtual &&
          outro.posicao != null &&
          outro.posicao.equals(posicao)) {

        return true;
      }
    }

    return false;
  }


  boolean posicaoReservada(
    Coordenada posicao,
    Coordenada[] movimentos,
    int limite
  ) {

    for (int i = 0; i < limite; i++) {

      if (movimentos[i] != null &&
          movimentos[i].equals(posicao)) {

        return true;
      }
    }

    return false;
  }
}
