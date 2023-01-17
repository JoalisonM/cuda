#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cuda.h>

#define LEN_LINHA 1024 // declara um número grande para poder caber tudo
#define LINHAS 100
#define COLUNAS 100

__global__ void mult_EscalarXMatriz(int escalar, int *matriz, int nlinhas, int ncolunas)
{
  // threadIdx.y e threadIdx.x contém a linha e a coluna respectivamente deste thread no grid
  int i = threadIdx.y; // linha
  int j = threadIdx.x; // coluna

  matriz[i * COLUNAS + j] = escalar * matriz[i * COLUNAS + j];
}

int main()
{
  char *str;
  int *matriz;
  char linha[LEN_LINHA]; // esse é o tamanho máximo de uma linha que o programa pode tratar
  dim3 grid_dims, block_dims;
  int linhas, colunas, numero;

  // Como não sabemos as dimensões máximas da matriz, vamos alocar uma quantidade
  // de memória "grande". Infelizmente é assim quando não sabemos qual vai ser o
  // tamanho da matriz
  cudaMallocManaged(&matriz, sizeof(int) * LINHAS * COLUNAS);

  while (fgets(linha, LEN_LINHA, stdin) != NULL && strcmp(linha, "FIM\n"))
  {
    // Agora que leu e sabemos  que é diferente de FIM vamos ler o número a ser multiplicado
    sscanf(linha, "%d", &numero);

    // === Agora vamos ler a matriz ===
    linhas = 0;

    // Lê uma linha da entrada padrão e testar para saber se não é uma
    // linha em branco. Se for encerra a leitura da matriz
    while (fgets(linha, LEN_LINHA, stdin) != NULL && strcmp(linha, "\n"))
    {
      colunas = 0;

      // Vamos separar a string de acordo com o separador
      str = strtok(linha, " "); // Separa a string usando tokens
      do
      {
        // Converte para inteiro e armazena na matriz
        matriz[linhas * LINHAS + colunas] = strtol(str, NULL, 10);
        colunas++;

        // Pega uma outra string. Caso seja um espaço vazio encerra o programa
      } while ((str = strtok(NULL, " ")) != NULL && strcmp(str, "\n"));
      linhas++; // Vamos incrementar para no fim saber quantas linhas foram informadas
    }

    // === Fim do código para ler a matriz ===

    // Pronto. Quando chegar aqui já leu o número e a matriz.
    // As variáveis linhas e colunas tem as dimensões da matriz.

    grid_dims.x = 1;
    grid_dims.y = 1;
    grid_dims.z = 1;
    block_dims.x = colunas;
    block_dims.y = linhas;
    block_dims.z = 1;

    // Cria os threads
    mult_EscalarXMatriz<<<grid_dims, block_dims>>>(numero, matriz, linhas, colunas);

    // Aguarda a conclusão de todos eles
    cudaDeviceSynchronize();

    // Imprimi a matriz
    for (int i = 0; i < linhas; i++)
    {
      for (int j = 0; j < colunas; j++)
      {
        printf("%d ", matriz[i * COLUNAS + j]);
      }
      printf("\n");
    }
    printf("\n");
  }

  cudaFree(matriz);

  return 0;
}