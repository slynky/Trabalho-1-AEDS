
int i = -1, j = -1;
void ordenar() {
  mergeSort(agentes, 0, totalAgentes - 1);
}


void mergeSort(Individuo[] arr, int l, int r) {
  if (l < r) {
    int m = l + (r - l) / 2;
    mergeSort(arr, l, m);
    mergeSort(arr, m + 1, r);
    merge(arr, l, m, r);
  }
}

void merge(Individuo[] arr, int l, int m, int r) {
  int n1 = m - l + 1;
  int n2 = r - m;

  Individuo[] L = new Individuo[n1];
  Individuo[] R = new Individuo[n2];

  for (int x = 0; x < n1; x++) L[x] = arr[l + x];
  for (int y = 0; y < n2; y++) R[y] = arr[m + 1 + y];

  int x = 0, y = 0, k = l;

  while (x < n1 && y < n2) {
    i = k; // Atualiza visualização
    delay(100); // delay
   if (L[x].contador <= R[y].contador) {
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
