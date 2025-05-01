// Tamanho do grid
int tamanho = 60;

// Grid onde -1 significa célula vazia e qualquer outro valor é índice no vetor de agentes
int grid[][] = new int[tamanho][tamanho];

// Vetor com até 200 agentes
Individuo agentes[] = new Individuo[200];
int totalAgentes = 0;

void setup() {
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
  for (int i = 0; i < totalAgentes; i++) {
    //cria o bglh de mostrar eles
  }

  // Descobre a célula clicada
  int i = int(mouseX / (width / float(tamanho)));
  int j = int(mouseY / (height / float(tamanho)));
  
  for (Individuo ind: agentes) {
    if ((frameCount % ind.tempoReacao) == 0){
    move(ind);
    }
  }

  // Se o botão esquerdo for clicado, infecta o agente na célula
  if (mousePressed && mouseButton == LEFT && i < tamanho && j < tamanho) {
    if (grid[i][j] != -1) {
      int z = grid[i][j];
      agentes[z].estado = Estado.INFECTADO;
    }
  }

  // Se o botão direito for clicado, torna o agente suscetível novamente
  if (mousePressed && mouseButton == RIGHT && i < tamanho && j < tamanho) {
    if (grid[i][j] != -1) {
      int z = grid[i][j];
      agentes[z].estado = Estado.SUSCETIVEL;
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


void move(Individuo i) {
  // Gera um deslocamento aleatório (exceto ficar parado)
  int dx = 0;
  int dy = 0;

  // Garante que não seja (0,0)
  while (dx == 0 && dy == 0) {
    dx = int(random(-1, 2)); // -1, 0 ou 1
    dy = int(random(-1, 2)); // -1, 0 ou 1
  }

  int nx = i.x + dx;
  int ny = i.y + dy;

  // Verifica se o novo local está dentro do grid e está livre
  if (nx >= 0 && nx < tamanho && ny >= 0 && ny < tamanho && grid[nx][ny] == -1) {
    int idx = IndPos(i);
    grid[i.x][i.y] = -1;      // libera a posição antiga
    grid[nx][ny] = idx;       // ocupa a nova
    i.x = nx;
    i.y = ny;
  }
}

int IndPos(Individuo i) {
  for (int z = 0; z < totalAgentes; z++) {
    if (agentes[z] == i) {
      return z; // encontrou o índice do agente no vetor
    }
  }
  return -1; // erro, não achou 
}
