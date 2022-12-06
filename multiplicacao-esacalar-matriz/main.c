#include <stdio.h>
#include <string.h>

int inputs[1000000];
int arrayPosition = 0;

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

int getItems(char *string, int sizeString)
{
  int answer = 1;
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

  int n = stringToInt(number, position);
  inputs[arrayPosition] = n;
  (arrayPosition)++;
  position = 0;

  for (int i = 0; i < sizeString; i++)
    if (string[i] == ' ')
      answer++;

  return answer;
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
    int n = 0, m;
    arrayPosition = 0;

    while (1)
    {
      char line[1000000];
      readLine(line);
      if (strcmp(line, "") == 0)
        break;
      m = getItems(line, strlen(line));
      n++;
    }

    int matriz[n][m];

    for (int i = 0; i < n; i++)
    {
      for (int j = 0; j < m; j++)
      {
        matriz[i][j] = inputs[i * m + j] * escalar;
        printf("%2d ", matriz[i][j]);
      }
      printf("\n");
    }
    printf("\n");
  }

  return 0;
}