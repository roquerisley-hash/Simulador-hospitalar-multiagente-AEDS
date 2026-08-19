// base (fornecida pelo lucas) para localizar as estruturas pelo mapa

class Coordenada {
  int linha;
  int coluna;

  Coordenada(int linha, int coluna) {
    this.linha = linha;
    this.coluna = coluna;
  }

  Coordenada copy() {
    return new Coordenada(linha, coluna);
  }

  boolean equals(Coordenada outra) {
    return outra != null &&
           linha == outra.linha &&
           coluna == outra.coluna;
  }
}
