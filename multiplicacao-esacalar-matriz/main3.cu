#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cuda.h>

#define LEN_LINHA   1024
#define LINHAS      100
#define COLUNAS     100

__global__ void multplicacaoEscalarMatriz(int linhas, int colunas, int escalar, int *matriz)
{
  for (int i = 1; i < linhas; i++)
  {
    for (int j = 0; j < colunas; j++)
    {
      int multiplicacao = matriz[i*COLUNAS+j] * escalar;
      matriz[i*COLUNAS+j] = multiplicacao;
    }
  }
  return;
}

int main()
{
  char *str;
  int *matriz; // host
  char linha[LEN_LINHA];
  int linhas, colunas, escalar;

  cudaMallocManaged(&matriz, sizeof(int)*LINHAS*COLUNAS); // device

  while(fgets(linha, LEN_LINHA, stdin) != NULL && strcmp(linha, "FIM\n")) {
    sscanf(linha, "%d", &escalar);

    linhas = 0;

    while(fgets(linha, LEN_LINHA, stdin) != NULL && strcmp(linha, "\n")) {
      colunas = 0;

      str = strtok(linha, " "); // Separa a string usando tokens    ['1', '2', '3']
      do {
        matriz[linhas*LINHAS+colunas] = strtol(str, NULL, 10);
        colunas++;
      }while((str=strtok(NULL, " "))  != NULL && strcmp(str, "\n"));
      linhas++;
    }

    multplicacaoEscalarMatriz<<<1, 1>>>(linhas, colunas, escalar, matriz);
    cudaDeviceSynchronize();

    for(int i=0; i<linhas; i++){
      for(int j=0; j<colunas; j++){
        printf("%2d ", matriz[i*COLUNAS+j]);
      }
      printf("\n");
    }
    printf("\n");

  }
  
  cudaFree(matriz);

  return 0;
}