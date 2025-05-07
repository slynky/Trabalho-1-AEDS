// Tamanho do grid
int tamanho = 40;

// Grid onde -1 significa célula vazia e qualquer outro valor é índice no vetor de agentes
int grid[][] = new int[tamanho][tamanho];

// Vetor com até 200 agentes
Individuo agentes[] = new Individuo[200];
int totalAgentes = 0;
int nA = 100; //numero de agentes inicialmente

void setup() {
  frameRate(60);
  size(1200, 800);
  // Inicializa todas as células como vazias
  for (int x = 0; x < tamanho; x++) {
    for (int y = 0; y < tamanho; y++) {
      grid[x][y] = -1;
    }
  }

  while (totalAgentes < nA) {
    int x = int(random(tamanho));
    int y = int(random(tamanho));
    if (grid[x][y] == -1) {
      agentes[totalAgentes] = new Individuo(x, y, random(1) < 0.6 ? Estado.SUSCETIVEL : Estado.INFECTADO);
      grid[x][y] = totalAgentes;
      totalAgentes++;
      
    }
  }
}
void draw() {
  background(255);
  MostraGrid();

  for (int i = 0; i < totalAgentes; i++) {
    Individuo ind = agentes[i];
    if (ind == null) continue;

    
    switch (ind.estado) {
      case SUSCETIVEL:
        fill(0, 0, 255); // Azul
        break;
      case INFECTADO:
        fill(255, 0, 0); // Vermelho
        break;
      case IMUNE:
        fill(0, 255, 0); // Verde
        break;
      }
  }

  // Descobre a célula clicada
  int i = int(mouseX / (width / float(tamanho)));
  int j = int(mouseY / (height / float(tamanho)));

   for (int g = 0; g < totalAgentes; g++) {
    if (agentes[g] == null) continue;
    if ((frameCount % agentes[g].tempoReacao) == 0) {

       move(agentes[g] ,g);
    }
    if (agentes[g].estado == Estado.IMUNE)continue;
    if ((frameCount % agentes[g].tempoReacao) == 0 && agentes[g].estado == Estado.INFECTADO) {
      infecta(g);
    }
    if (agentes[g].estado == Estado.INFECTADO) agentes[g].tempoInfectado++; //conta o tempo para ser curado
    if (agentes[g].tempoInfectado >= (agentes[g].tempoReacao * 20) ) agentes[g].estado = Estado.IMUNE; //CURA
  }

  // Botão esquerdo: infecta
  if (mousePressed && mouseButton == LEFT && i < tamanho && j < tamanho && i >= 0 && j >= 0) {
    if (grid[i][j] != -1) {
      int z = grid[i][j];
      agentes[z].estado = Estado.INFECTADO;
    } else if (totalAgentes < 200){
        agentes[totalAgentes] = new Individuo(i, j, Estado.INFECTADO);
        grid[i][j] = totalAgentes;
        totalAgentes++;

    }
  }

  // Botão direito: torna suscetível
  if (mousePressed && mouseButton == RIGHT && i < tamanho && j < tamanho && i >= 0 && j >= 0) {
    if (grid[i][j] != -1) {
      int z = grid[i][j];
      if (z >= 0 && z < agentes.length && agentes[z] != null) {
        agentes[z].estado = Estado.SUSCETIVEL;  // ou INFECTADO
      }

    } else if (totalAgentes < 200){
        agentes[totalAgentes] = new Individuo(i, j, Estado.SUSCETIVEL);
        grid[i][j] = totalAgentes;
        totalAgentes++;

    }
  }
  
  //ordenar();

  // ranking dos 5 que mais infectaram
  fill(0);
  textSize(16);
  textAlign(LEFT);
  
  text("Ranking - mais infectaram:", 20, height - 120);
  int mostrados = 0;
  for (int k = totalAgentes - 1; k >= 0 && mostrados < 5; k--){
    if (agentes[k] != null){
      text("Agente #" + k + " infectou " + agentes[k].contador + " pessoa(s)", 20, height - 100 + 20 * mostrados);
      mostrados++;
    }
  }

}


// Mostra o grid com cores conforme o estado de cada agente
void MostraGrid() {
  float l = width  / (float)tamanho;  // largura da célula
  float h = height / (float)tamanho;  // altura da célula

  for (int i = 0; i < tamanho; i++) {
    for (int j = 0; j < tamanho; j++) {
      if (grid[i][j] != -1) {
        // pega o agente que está nessa célula
        int idx = grid[i][j];
        Estado est = agentes[idx].estado;

        switch (est) {
          case SUSCETIVEL:
            fill(0, 0, 255);   // azul
            break;
          case INFECTADO:
            fill(255, 0, 0);   // vermelho
            break;
          case IMUNE:
            fill(0, 255, 0);   // verde
            break;
        }
      } else {
        fill(200);            // célula vazia = cinza claro
      }
      rect(i * l, j * h, l, h);
    }
  }
}

void move(Individuo ind, int idx) {
  int dx, dy;
  // Gera um deslocamento apenas em −1, 0 ou +1 para cada eixo
  do {
    dx = ind.x + (int)random(3) - 1;  // random(3) retorna [0,3), subtrai 1 → {−1,0,1}
    dy = ind.y + (int)random(3) - 1;
  } while (dx < 0 || dy < 0 || dx >= tamanho || dy >= tamanho);

  // Se a célula destino estiver livre, efetua a troca
  if (grid[dx][dy] == -1) {
    grid[ind.x][ind.y] = -1;   // limpa a célula antiga
    ind.x = dx;                // atualiza a posição no objeto
    ind.y = dy;
    grid[dx][dy] = idx;        // marca a nova célula
  }
}




void infecta(int g) {
  int ix = 0, iy = 0;

  // Gera deslocamento diferente de (0,0)
  while (ix == 0 && iy == 0 ) {
    ix = (int)random(3) - 1;// -1, 0 ou 1
    iy = (int)random(3) - 1; // -1, 0 ou 1
  }

  int nx = agentes[g].x + ix;
  int ny = agentes[g].y + iy;

  // Verifica se está dentro do grid
  if (nx >= 0 && nx < tamanho && ny >= 0 && ny < tamanho) {
    int alvo = grid[nx][ny];
    
    if (alvo != -1) {
      Individuo vizinho = agentes[alvo];
      
      if (vizinho.estado == Estado.SUSCETIVEL) {
        if (random(1) < 0.8) {
          vizinho.estado = Estado.INFECTADO;
          agentes[g].contador++;
          agentes[alvo] = vizinho;
        }
      }
    } 
  }
}
