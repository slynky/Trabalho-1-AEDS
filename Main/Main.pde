// Tamanho do grid
int tamanho = 60;

// Grid onde -1 significa célula vazia e qualquer outro valor é índice no vetor de agentes
int grid[][] = new int[tamanho][tamanho];

// Vetor com até 200 agentes
Individuo agentes[] = new Individuo[200];
int totalAgentes = 0;

void setup() {
  frameRate(60);
  size(1200, 800);
  // Inicializa todas as células como vazias
  for (int x = 0; x < tamanho; x++) {
    for (int y = 0; y < tamanho; y++) {
      grid[x][y] = -1;
    }
  }

  // Cria até 50 agentes em posições aleatórias não ocupadas
  while (totalAgentes < 50) {
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

  // Mostra todos os agentes com a cor baseada no estado
  float l = width / float(tamanho);
  float h = height / float(tamanho);

  for (int i = 0; i < totalAgentes; i++) {
    Individuo ind = agentes[i];

    
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

    float px = ind.x * l + l / 2;
    float py = ind.y * h + h / 2;
    ellipse(px, py, l * 0.8, h * 0.8); // círculo representando o agente
  }

  // Descobre a célula clicada
  int i = int(mouseX / (width / float(tamanho)));
  int j = int(mouseY / (height / float(tamanho)));

  for (Individuo ind : agentes) {
    if (ind == null) continue;
    if ((frameCount % ind.tempoReacao) == 0) {
       move();
    }
    if ((frameCount % ind.tempoReacao) == 0 && ind.estado == Estado.INFECTADO) {
      infecta(ind);
    }
  }

  // Botão esquerdo: infecta
  if (mousePressed && mouseButton == LEFT && i < tamanho && j < tamanho && i >= 0 && j >= 0) {
    if (grid[i][j] != -1) {
      int z = grid[i][j];
      agentes[z].estado = Estado.INFECTADO;
    }
  }

  // Botão direito: torna suscetível
  if (mousePressed && mouseButton == RIGHT && i < tamanho && j < tamanho && i >= 0 && j >= 0) {
    if (grid[i][j] != -1) {
      int z = grid[i][j];
      agentes[z].estado = Estado.SUSCETIVEL;
    }
  }
  thread("ordenar");
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

void move() {

}



void infecta(Individuo ind) {
  int ix = 0, iy = 0;

  // Gera deslocamento diferente de (0,0)
  while (ix == 0 && iy == 0) {
    ix = int(random(-1, 2)); // -1, 0 ou 1
    iy = int(random(-1, 2)); // -1, 0 ou 1
  }

  int nx = ind.x + ix;
  int ny = ind.y + iy;

  // Verifica se está dentro do grid
  if (nx >= 0 && nx < tamanho && ny >= 0 && ny < tamanho) {
    int alvo = grid[nx][ny];
    
    if (alvo != -1) {
      Individuo vizinho = agentes[alvo];
      
      if (vizinho.estado == Estado.SUSCETIVEL) {
        if (random(1) < 0.8) {
          vizinho.estado = Estado.INFECTADO;
        }
      }
    }
  }
}
