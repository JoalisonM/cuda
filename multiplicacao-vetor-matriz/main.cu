#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cuda.h>

#define LEN_LINHA 1024 // declara um número grande para poder caber tudo
#define LINHAS 100
#define COLUNAS 100

__global__ void mult_vetorxmatriz(int *matriz1, int *matriz2, int *resultado, int nColunas)
{
  int j = threadIdx.x;

  resultado[j] = 0;

  for (int i = 0; i < nColunas; i++)
  {
    resultado[j] += matriz1[i] * matriz2[i * COLUNAS + j];
  }
}

int main(int argc, char **argv)
{
  char *str;
  int linhas, colunas;
  char linha[LEN_LINHA]; // esse é o tamanho máximo de uma linha que o programa pode tratar
  dim3 grid_dims, block_dims;
  int *matriz, *vetor, *resultado;

  // Como não sabemos as dimensões máximas da matriz, vamos alocar uma quantidade
  // de memória "grande". Infelizmente é assim quando não sabemos qual vai ser o
  // tamanho da matriz

  cudaMallocManaged(&vetor, sizeof(int) * COLUNAS);
  cudaMallocManaged(&matriz, sizeof(int) * LINHAS * COLUNAS);
  cudaMallocManaged(&resultado, sizeof(int) * LINHAS * COLUNAS);

  // vamos primeiro ler a linha e ver se o usuário digitou FIM
  while (fgets(linha, LEN_LINHA, stdin) != NULL && strcmp(linha, "FIM\n"))
  {
    // vamos separar a string de acordo com o separador
    str = strtok(linha, " "); // separa a string usando tokens
    colunas = 0;

    do
    {
      // converte para inteiro e armazena na matriz
      vetor[colunas] = strtol(str, NULL, 10);
      colunas++;

      // pega uma outra string. Caso seja um espaço vazio encerra o programa
    } while ((str = strtok(NULL, " ")) != NULL && strcmp(str, "\n"));

    linhas = 0;

    // lê uma linha da entrada padrão e testa para saber se não é uma
    // linha em branco, linha em branco encerra a leitura da matriz
    while (fgets(linha, LEN_LINHA, stdin) != NULL && strcmp(linha, "\n"))
    {
      colunas = 0;
      // vamos separar a string de acordo com o separador
      str = strtok(linha, " "); // separa a string usando tokens

      do
      {
        matriz[linhas * LINHAS + colunas] = strtol(str, NULL, 10);
        colunas++;

        // pega uma outra string. Caso seja um espaço vazio encerra o programa
      } while ((str = strtok(NULL, " ")) != NULL && strcmp(str, "\n"));
      linhas++; // vamos incrementar para no fim saber quantas linhas foram informadas
    }

    // === FIM do código para ler a matriz ===

    // Pronto. Quando chegar aqui já leu o número e a matriz.
    // As variáveis linhas e colunas tem as dimensões da matriz

    // É só fazer as contas

    grid_dims.x = 1;
    grid_dims.y = 1;
    grid_dims.z = 1;
    block_dims.x = colunas;
    block_dims.y = 1;
    block_dims.z = 1;

    mult_vetorxmatriz<<<grid_dims, block_dims>>>(vetor, matriz, resultado, colunas);
    cudaDeviceSynchronize();

    // e depois imprimir
    for (int i = 0; i < 1; i++)
    {
      for (int j = 0; j < colunas; j++)
      {
        printf("%d ", resultado[i * COLUNAS + j]);
      }
      printf("\n");
    }
    printf("\n");
  }

  cudaFree(vetor);
  cudaFree(matriz);
  cudaFree(resultado);

  return 0;
}