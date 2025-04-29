enum Estado{
 SUSCETIVEL, INFECTADO, IMUNE 
}


class Individuo{
  
//Suscetível (saudável) – Azul - 1
//Infectado (doente) – Vermelho - (-1)
//Recuperado (imune) – Verde - 0

  int x;
  int y;
  Estado estado;
  int tempo_reacao; //random //movimentação e transmissão da doença). Por exemplo, a cada 30 a 120 frames, ele escolhe uma célula vizinha vazia aleatoriamente para se mover.
  int tempo_infectado;
  int contador;
  
  Individuo(int x, int y, Estado estado){
    this.x = x;
    this.y = y;
    this.estado = estado;
    tempo_reacao = int(random(30, 120));
    contador = 0;
    tempo_infectado = 0;
  }
}
