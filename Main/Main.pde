// Tamanho do grid
int tamanho = 50;

// Grid onde -1 significa célula vazia e qualquer outro valor é índice no vetor de agentes
int grid[][] = new int[tamanho][tamanho];

// Vetor com até 200 agentes
Individuo agentes[] = new Individuo[200];
int totalAgentes = 0;

void setup() {
  size(900, 800);
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

// Mostra o grid cinza com células brancas onde há agentes
void MostraGrid() {
  float l = width / (float)tamanho;
  float h = height / (float)tamanho;

  for (int i = 0; i < tamanho; i++) {
    for (int j = 0; j < tamanho; j++) {
      if (grid[i][j] != -1) {
        fill(255); // célula com agente
      } else {
        fill(118); // célula vazia
      }
      rect(i * l, j * h, l, h);
    }
  }
}
