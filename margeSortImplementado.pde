int n = 5; // numero de comparações
Elemento[] array = new Elemento[n];
int i = -1, j = -1;

class Elemento {
  int valor;
  int indiceOriginal;

  Elemento(int valor, int indiceOriginal) {
    this.valor = valor;
    this.indiceOriginal = indiceOriginal;
  }
}

void setup() {
  size(800, 600);
  for (int k = 0; k < array.length; k++) {
    array[k] = new Elemento((int) random(height), k); // Armazena valor e índice original
  }
  thread("ordenar");
}

void draw() {
  background(220);
  int l = width / n;
  for (int k = 0; k < n; k++) {
    int h = array[k].valor;
    if (k == i || k == j) fill(100, 250, 100);
    else fill(100, 100, 250);
    rect(k * l, height - h, l, h);
    fill(0);
    textAlign(CENTER);
    text(str(array[k].valor), k * l + l / 2, height - h - 15); // quantidade infectados
    text(str(array[k].indiceOriginal), k * l + l / 2, height - h + 15); // individuo (índice original)
  }

  if (mousePressed) {
    for (int k = 0; k < array.length; k++) {
      array[k] = new Elemento((int) random(height), k); // Reinicia com novos valores e índices
    }
    thread("ordenar");
  }
}

void ordenar() {
  mergeSort(array, 0, array.length - 1);
}

void mergeSort(Elemento[] arr, int l, int r) {
  if (l < r) {
    int m = l + (r - l) / 2;
    mergeSort(arr, l, m);
    mergeSort(arr, m + 1, r);
    merge(arr, l, m, r);
  }
}

void merge(Elemento[] arr, int l, int m, int r) {
  int n1 = m - l + 1;
  int n2 = r - m;

  Elemento[] L = new Elemento[n1];
  Elemento[] R = new Elemento[n2];

  for (int x = 0; x < n1; x++) L[x] = arr[l + x];
  for (int y = 0; y < n2; y++) R[y] = arr[m + 1 + y];

  int x = 0, y = 0, k = l;

  while (x < n1 && y < n2) {
    i = k; // Atualiza visualização
    delay(100); // delay
    if (L[x].valor <= R[y].valor) {
      arr[k] = L[x];
      x++;
    } else {
      arr[k] = R[y];
      y++;
    }
    k++;
  }

  while (x < n1) {
    i = k;
    delay(100); // delay
    arr[k++] = L[x++];
  }

  while (y < n2) {
    i = k;
    delay(100); // delay
    arr[k++] = R[y++];
  }

  i = -1; // Limpa destaque
}
