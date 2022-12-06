#include <stdio.h>
#include <cuda.h>

int main(int argc, char **argv)
{
  int *matriz;
  int linhas, colunas;

  while ((scanf("%d %d", &linhas, &colunas) == 2) && (linhas > 0 && colunas > 0))
  {
    cudaMallocManaged(&matriz, sizeof(int)*linhas*colunas);

    for (int i = 0; i < linhas; i++)
    {
      for (int j = 0; j < colunas; j++)
      {
        scanf("%d", &matriz[i*colunas+j]);
      }
    }

    for (int i = 0; i < linhas; i++)
    {
      for (int j = 0; j < colunas; j++)
      {
        printf("%2d", matriz[i*colunas+j]);
      }
      printf("\n");
    }
    printf("\n");
    cudaFree(matriz);
  }

  return 0;
}