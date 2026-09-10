class Paciente {
  
  int id;
  boolean ehPreferencial;
  String senha;
  
  Coordenada posicao;
  Coordenada destino;
  
  int saturacaoOxigenio;
  float temperaturaCorporal;
  int nivelDor;
  boolean conscienciaAlterada;
  
  EstadoPaciente estado;

  // preenchido quando o paciente passa pela classificação de Manchester
  // (null antes disso — ainda não tem cor de prioridade médica)
  String classificacaoManchester = null;
  
  Paciente(int id, int numNormal, int numPreferencial, Coordenada posicao, Coordenada destino) {
    this.id = id;
    this.ehPreferencial = random(1) < 0.25 ? true : false;
    
    if(ehPreferencial) {
      this.senha = "P" + numPreferencial;
    } else {
      this.senha = "N" + numNormal;
    }
    
    this.posicao = posicao.copy();
    this.destino = destino.copy();
    
    saturacaoOxigenio = (int) random(70, 100);
    temperaturaCorporal = random(34, 42);
    nivelDor = (int) random(0, 10);
    conscienciaAlterada = random(1) > 0.25 ? false : true;
                          
    this.estado = EstadoPaciente.INDO_TOTEM;
  }

  void desenhar() {
    float x = origemX + posicao.coluna * tamanhoCelula;
    float y = origemY + posicao.linha * tamanhoCelula;

    PImage sprite = ehPreferencial ? imgPacientePreferencial : imgPacienteNormal;

    if (sprite != null) {
      image(sprite, x, y, tamanhoCelula, tamanhoCelula);
    } else {
      noStroke();
      fill(ehPreferencial ? corPacientePreferencial : corPacienteNormal);
      ellipse(x + tamanhoCelula / 2.0, y + tamanhoCelula / 2.0, tamanhoCelula * 0.55, tamanhoCelula * 0.55);
    }

    if (classificacaoManchester != null) {
      noStroke();
      fill(corDaClassificacaoManchester(classificacaoManchester));
      rect(x, y, tamanhoCelula, tamanhoCelula);
    }
  }
}
