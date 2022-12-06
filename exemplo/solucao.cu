#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cuda.h>

#define LEN_LINHA   1024    // Declara um número grande para poder caber tudo
#define LINHAS      100
#define COLUNAS     100

int main(int argc, char **argv){
    char *str;
    int *matriz;
    int linhas, colunas, numero;
    char linha[LEN_LINHA]; // Esse é o tamanho máximo de uma linha que o programa pode tratar

    // Como não sabemos as dimensões máximas da matriz, vamos alocar uma quantiade
    // de memória "grande". Infelizmente é assim quando não sabemos qual vai ser o 
    // tamanho da matriz
    cudaMallocManaged(&matriz, sizeof(int)*LINHAS*COLUNAS);

    // Vamos primeiro ler a linha e ver se o usuário digitou FIM
    while(fgets(linha, LEN_LINHA, stdin) != NULL && strcmp(linha, "FIM\n")){
        // Agora que leu e sabemos que é diferente de FIM vamos ler o número  a ser
        // multiplicado
        sscanf(linha, "%d", &numero);
        
        // ============== Agora vamos ler a matriz ===================================
        linhas = 0;
        // Le uma linha da entrada padrão e testa para saber se não é uma linha em branco
        // linha em branco encerra a leitura da matriz
        while(fgets(linha, LEN_LINHA, stdin) != NULL && strcmp(linha, "\n")){
            colunas = 0;
            // Vamos separar a string de acordo com o separador
            str = strtok(linha," "); // Separa a string usando tokens
            do{ 
                // Converte para inteiro e armazena na matriz
                matriz[linhas*LINHAS+colunas] = strtol(str, NULL, 10);
                colunas++;

                // Pega uma outra string. Caso seja um espaço vazio encerra o programa
            }while((str=strtok(NULL, " ")) != NULL && strcmp(str, "\n")); 
            linhas++; // Vamos incrementar para no fim saber quantas linhas foram informadas
        }
        // ============= Fim do código para ler a matriz ============================

        // Pronto. Quando chegar aqui já leu o número e a matriz. 
        // As variáveis linhas e colunas tem as dimensões da matriz

        // Eh só fazer as contas

        // E depois imprimir
        for(int i=0; i<linhas; i++){
            for(int j=0; j<colunas; j++){
                printf("%d ", matriz[i*LINHAS+j]);
            }
            printf("\n");
        }
    }

    cudaFree(matriz);

    return 0;
}