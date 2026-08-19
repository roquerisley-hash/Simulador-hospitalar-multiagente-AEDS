class No<X> {
  X dado;
  No proximo;

  No(X dado) {
    this.dado = dado;
    this.proximo = null;
  }
}

class ListaEncadeada<T> {
  No<T> cabeca; //head

  void add(T dado) {
    No<T> novoNo = new No<T>(dado);
    if (cabeca == null) {
      cabeca = novoNo;
    } else {
      No atual = cabeca;
      while (atual.proximo != null) {
        atual = atual.proximo;
      }
      atual.proximo = novoNo;
    }
  }
  
  void add(T dado, int pos){
    No<T> novoNo = new No<T>(dado);
    if(cabeca == null) cabeca = novoNo;
    else{
      if(pos == 0){
          novoNo.proximo = cabeca;
          cabeca = novoNo;      
      }
  
      No atual = cabeca;
      while(pos > 1 && atual.proximo != null){
        atual = atual.proximo;
        pos--;
      }
      
      novoNo.proximo = atual.proximo;
      atual.proximo = novoNo;
    }
  }

  int count(){
    if(cabeca == null) return 0;
    int cnt = 1;
    No atual = cabeca;
    while(atual.proximo != null){
      atual = atual.proximo;
      cnt++;
    }
    
    return cnt;
  }
  
  T get(int pos){
    No atual = cabeca;
    while(pos > 0){ //Cuidado
      atual = atual.proximo;
      pos--;
    }
    
    return (T)atual.dado;
  }
  
  void set(int pos, T val){
    No atual = cabeca;
    while(pos > 0){ //Cuidado
      atual = atual.proximo;
      pos--;
    }
    atual.dado = val;
  }
}
