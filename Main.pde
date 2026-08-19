final int LARGURA_JANELA = 800;
final int ALTURA_JANELA = 600;

String nomeArquivo = "mapa_hospital_professor.txt";

void settings() {
  size(LARGURA_JANELA, ALTURA_JANELA);
}

void setup() {
  inicializarCoresMapa();
  carregarMapa(nomeArquivo);
}

void draw() {
  background(245);
  if (!mensagemErro.equals("")) {
    desenharErro();
    return;
  }
  desenharMapa();
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    carregarMapa(nomeArquivo);
  }
}
