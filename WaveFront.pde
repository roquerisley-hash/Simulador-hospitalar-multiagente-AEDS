class WaveFront {

  ListaEncadeada<Coordenada> encontrarCaminho(
    char[][] mapa,
    Coordenada origem,
    Coordenada destino
  ) {

    ListaEncadeada<Coordenada> caminho =
      new ListaEncadeada<Coordenada>();

    if (!coordenadaValida(mapa, origem) ||
        !coordenadaValida(mapa, destino)) {

      return caminho;
    }

    if (origem.equals(destino)) {

      caminho.add(origem.copy());

      return caminho;
    }

    int[][] distancia =
      new int[mapa.length][mapa[0].length];

    for (int i = 0; i < mapa.length; i++) {

      for (int j = 0; j < mapa[i].length; j++) {

        distancia[i][j] = -1;
      }
    }

    FilaCoordenadas frente =
      new FilaCoordenadas();

    frente.enfileirar(origem.copy());

    distancia[origem.linha][origem.coluna] = 0;

    boolean encontrouDestino = false;

    while (!frente.vazia()) {

      Coordenada atual =
        frente.desenfileirar();

      if (atual.equals(destino)) {

        encontrouDestino = true;

        break;
      }

      int novaDistancia =
        distancia[atual.linha][atual.coluna] + 1;

      Coordenada cima =
        new Coordenada(
          atual.linha - 1,
          atual.coluna
        );

      if (coordenadaValida(mapa, cima) &&
          distancia[cima.linha][cima.coluna] == -1) {

        distancia[cima.linha][cima.coluna] =
          novaDistancia;

        frente.enfileirar(cima);
      }

      Coordenada baixo =
        new Coordenada(
          atual.linha + 1,
          atual.coluna
        );

      if (coordenadaValida(mapa, baixo) &&
          distancia[baixo.linha][baixo.coluna] == -1) {

        distancia[baixo.linha][baixo.coluna] =
          novaDistancia;

        frente.enfileirar(baixo);
      }

      Coordenada esquerda =
        new Coordenada(
          atual.linha,
          atual.coluna - 1
        );

      if (coordenadaValida(mapa, esquerda) &&
          distancia[esquerda.linha][esquerda.coluna] == -1) {

        distancia[esquerda.linha][esquerda.coluna] =
          novaDistancia;

        frente.enfileirar(esquerda);
      }

      Coordenada direita =
        new Coordenada(
          atual.linha,
          atual.coluna + 1
        );

      if (coordenadaValida(mapa, direita) &&
          distancia[direita.linha][direita.coluna] == -1) {

        distancia[direita.linha][direita.coluna] =
          novaDistancia;

        frente.enfileirar(direita);
      }
    }

    if (!encontrouDestino &&
        distancia[destino.linha][destino.coluna] == -1) {

      println(
        "Não existe caminho entre "
        + origem.linha + "," + origem.coluna
        + " e "
        + destino.linha + "," + destino.coluna
      );

      return caminho;
    }

    int tamanhoCaminho =
      distancia[destino.linha][destino.coluna] + 1;

    Coordenada[] caminhoTemporario =
      new Coordenada[tamanhoCaminho];

    Coordenada atual =
      destino.copy();

    int indice =
      tamanhoCaminho - 1;

    caminhoTemporario[indice] =
      atual.copy();

    indice--;

    while (!atual.equals(origem)) {

      int distanciaAtual =
        distancia[atual.linha][atual.coluna];

      Coordenada cima =
        new Coordenada(
          atual.linha - 1,
          atual.coluna
        );

      if (coordenadaValida(mapa, cima) &&
          distancia[cima.linha][cima.coluna]
          == distanciaAtual - 1) {

        atual = cima;

      } else {

        Coordenada baixo =
          new Coordenada(
            atual.linha + 1,
            atual.coluna
          );

        if (coordenadaValida(mapa, baixo) &&
            distancia[baixo.linha][baixo.coluna]
            == distanciaAtual - 1) {

          atual = baixo;

        } else {

          Coordenada esquerda =
            new Coordenada(
              atual.linha,
              atual.coluna - 1
            );

          if (coordenadaValida(mapa, esquerda) &&
              distancia[esquerda.linha][esquerda.coluna]
              == distanciaAtual - 1) {

            atual = esquerda;

          } else {

            Coordenada direita =
              new Coordenada(
                atual.linha,
                atual.coluna + 1
              );

            if (coordenadaValida(mapa, direita) &&
                distancia[direita.linha][direita.coluna]
                == distanciaAtual - 1) {

              atual = direita;
            }
          }
        }
      }

      caminhoTemporario[indice] =
        atual.copy();

      indice--;
    }

    for (int i = 0; i < tamanhoCaminho; i++) {

      caminho.add(
        caminhoTemporario[i]
      );
    }

    return caminho;
  }


  int[][] calcularDistancias(
    char[][] mapa,
    Coordenada destino
  ) {

    int[][] distancia =
      new int[mapa.length][mapa[0].length];

    for (int i = 0; i < mapa.length; i++) {

      for (int j = 0; j < mapa[i].length; j++) {

        distancia[i][j] = -1;
      }
    }

    if (!coordenadaValida(mapa, destino)) {
      return distancia;
    }

    FilaCoordenadas frente =
      new FilaCoordenadas();

    frente.enfileirar(
      destino.copy()
    );

    distancia[destino.linha][destino.coluna] = 0;

    while (!frente.vazia()) {

      Coordenada atual =
        frente.desenfileirar();

      int novaDistancia =
        distancia[atual.linha][atual.coluna] + 1;

      Coordenada cima =
        new Coordenada(
          atual.linha - 1,
          atual.coluna
        );

      if (coordenadaValida(mapa, cima) &&
          distancia[cima.linha][cima.coluna] == -1) {

        distancia[cima.linha][cima.coluna] =
          novaDistancia;

        frente.enfileirar(cima);
      }

      Coordenada baixo =
        new Coordenada(
          atual.linha + 1,
          atual.coluna
        );

      if (coordenadaValida(mapa, baixo) &&
          distancia[baixo.linha][baixo.coluna] == -1) {

        distancia[baixo.linha][baixo.coluna] =
          novaDistancia;

        frente.enfileirar(baixo);
      }

      Coordenada esquerda =
        new Coordenada(
          atual.linha,
          atual.coluna - 1
        );

      if (coordenadaValida(mapa, esquerda) &&
          distancia[esquerda.linha][esquerda.coluna] == -1) {

        distancia[esquerda.linha][esquerda.coluna] =
          novaDistancia;

        frente.enfileirar(esquerda);
      }

      Coordenada direita =
        new Coordenada(
          atual.linha,
          atual.coluna + 1
        );

      if (coordenadaValida(mapa, direita) &&
          distancia[direita.linha][direita.coluna] == -1) {

        distancia[direita.linha][direita.coluna] =
          novaDistancia;

        frente.enfileirar(direita);
      }
    }

    return distancia;
  }


  boolean coordenadaValida(
    char[][] mapa,
    Coordenada coordenada
  ) {

    if (coordenada == null) {
      return false;
    }

    if (coordenada.linha < 0) {
      return false;
    }

    if (coordenada.linha >= mapa.length) {
      return false;
    }

    if (coordenada.coluna < 0) {
      return false;
    }

    if (coordenada.coluna >= mapa[coordenada.linha].length) {
      return false;
    }

    if (mapa[coordenada.linha][coordenada.coluna] == '#') {
      return false;
    }

    if (mapa[coordenada.linha][coordenada.coluna] == 'E') {
      return false;
    }

    if (mapa[coordenada.linha][coordenada.coluna] == 'M') {
      return false;
    }

    return true;
  }
}
