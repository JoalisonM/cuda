#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cuda.h>

#define MAX_LINHAS 10
#define MAX_COLUNAS 10

__global__ void mult_matrizxmatriz(long int *matriz1, long int *matriz2, long int *resultado, int nlinhas1, int ncolunas1, int ncolunas2)
{
  int i = threadIdx.y; // linhas da matriz 1
  int j = threadIdx.x; // colunas da matriz 2

  resultado[i * ncolunas2 + j] = 0;

  for (int k = 0; k < ncolunas1; k++)
  {
    resultado[i * ncolunas2 + j] += matriz1[i * ncolunas1 + k] * matriz2[k * ncolunas2 + j];
  }
}

int main(int argc, char **argv)
{
  dim3 grid_dims, block_dims;
  long int *matriz1, *matriz2, *resultado;
  int nlinhas1, ncolunas1, nlinhas2, ncolunas2;

  // vou colocar as matrizes nas dimensões máximas mas caso elas fossem
  // grandes o ideal é alocar segundo a demanda.

  cudaMallocManaged(&matriz1, sizeof(int) * MAX_LINHAS * MAX_COLUNAS);
  cudaMallocManaged(&matriz2, sizeof(int) * MAX_LINHAS * MAX_COLUNAS);
  cudaMallocManaged(&resultado, sizeof(int) * MAX_LINHAS * MAX_COLUNAS);

  while ((scanf("%d %d", &nlinhas1, &ncolunas1) == 2) && nlinhas1 > 0 && ncolunas1 > 0)
  {
    for (int i = 0; i < nlinhas1; i++)
    {
      for (int j = 0; j < ncolunas1; j++)
      {
        if (scanf("%ld", &matriz1[i * ncolunas1 + j]) != 1)
          exit(1);
      }
    }

    nlinhas2 = ncolunas1;

    if (scanf("%d", &ncolunas2) != 1)
      exit(1);

    for (int i = 0; i < nlinhas2; i++)
    {
      for (int j = 0; j < ncolunas2; j++)
      {
        if (scanf("%ld", &matriz2[i * ncolunas2 + j]) != 1)
          exit(1);
      }
    }

    grid_dims.x = 1;
    grid_dims.y = 1;
    grid_dims.z = 1;
    block_dims.x = ncolunas2;
    block_dims.y = nlinhas1;
    block_dims.z = 1;

    mult_matrizxmatriz<<<grid_dims, block_dims>>>(matriz1, matriz2, resultado, nlinhas1, ncolunas1, ncolunas2);
    cudaDeviceSynchronize();

    for (int i = 0; i < nlinhas1; i++)
    {
      for (int j = 0; j < ncolunas2; j++)
      {
        printf("%2ld ", resultado[i * ncolunas2 + j]);
      }
      printf("\n");
    }
    printf("\n");
  }

  cudaFree(matriz1);
  cudaFree(matriz2);
  cudaFree(resultado);

  return 0;
}