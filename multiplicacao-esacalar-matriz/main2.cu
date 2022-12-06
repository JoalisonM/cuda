#include <stdio.h>
#include <string.h>
#include <cuda.h>

int arrayPosition = 0;

__global__ void multplicacaoEscalarMatriz(int linhas, int colunas, int escalar, int *matriz, int *inputs){
  for (int i = 0; i < linhas; i++)
  {
    for (int j = 0; j < colunas; j++)
    {
      int multiplicacao = inputs[i * colunas + j] * escalar;
      matriz[i*colunas+j] = multiplicacao;
    }
  }
  return;
}

void readLine(char *a)
{
  switch (scanf("%9999999[^\n]", a))
  {
  case 1:
    break;
  case 0:
    a[0] = 0;
    break;
  case EOF:
    return;
  }
  int ch;
  while ((ch = fgetc(stdin)) != '\n' && ch != EOF)
    ;
}

int stringToInt(char *string, int size)
{
  int ehNegativo = 0;

  if (string[0] == '-')
    ehNegativo = 1;

  int answer = 0;
  for (int i = ehNegativo; i < size; i++)
  {
    if (string[i] > '9' || string[i] < '0')
      break;
    answer *= 10;
    answer += string[i] - '0';
  }
  return (ehNegativo == 1 ? -answer : answer);
}

int getItems(int *inputs, char *string, int sizeString)
{
  int colunas = 0;
  char number[10];
  int position = 0;

  for (int i = 0; i < sizeString; i++)
  {
    if (string[i] != ' ')
    {
      number[position] = string[i];
      position++;
    }
    else
    {
      int n = stringToInt(number, position);
      inputs[arrayPosition] = n;
      (arrayPosition)++;
      position = 0;
    }
  }

  for (int i = 0; i < sizeString; i++)
    if (string[i] == ' ')
      colunas++;

  return colunas;
}

int main()
{

  while (1)
  {
    char initialNumber[1000000];
    readLine(initialNumber);
    if (strcmp(initialNumber, "FIM") == 0)
      break;

    int escalar = stringToInt(initialNumber, 18);
    int linhas = 0, colunas;
    int *matriz, *inputs;
    arrayPosition = 0;
  
    cudaMallocManaged(&inputs, sizeof(int)*1000000);

    while (1)
    {
      char line[1000000];
      readLine(line);
      if (strcmp(line, "") == 0)
        break;
      colunas = getItems(inputs, line, strlen(line));
      linhas++;
    }

    cudaMallocManaged(&matriz, sizeof(int)*linhas*colunas);
  
    multplicacaoEscalarMatriz<<<1, 1>>>(linhas, colunas, escalar, matriz, inputs);
    cudaDeviceSynchronize();
    
    for (int i = 0; i < linhas; i++)
    {
      for (int j = 0; j < colunas; j++)
      {
        printf("%2d ", matriz[i*colunas+j]);
      }
      printf("\n");
    }
    printf("\n");

    cudaFree(inputs);
    cudaFree(matriz);
  }

  return 0;
}