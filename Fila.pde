class NoFila{

  Coordenada dado;
  NoFila proximo;

  NoFila(Coordenada dado) {
    this.dado = dado;
    this.proximo = null;
  }
}


class FilaCoordenadas {

  NoFila inicio;
  NoFila fim;

  void enfileirar(Coordenada dado) {

    NoFila novoNo =
      new NoFila(dado);

    if (inicio == null) {

      inicio = novoNo;
      fim = novoNo;

    } else {

      fim.proximo = novoNo;
      fim = novoNo;
    }
  }


  Coordenada desenfileirar() {

    if (inicio == null) {
      return null;
    }

    Coordenada dado =
      inicio.dado;

    inicio =
      inicio.proximo;

    if (inicio == null) {
      fim = null;
    }

    return dado;
  }


  boolean vazia() {
    return inicio == null;
  }
}
