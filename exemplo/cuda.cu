#include <stdio.h>
#include <math.h>
#include <cuda.h>

#define f(x) 1 + sin(x)

__global__ void Dev_trap(
    const float a, // in
    const float h, // in
    const int   n, // in
    float *trap_p  // in/out
){
    int my_id = blockDim.x * blockIdx.x + threadIdx.x;

    if(0<my_id && my_id<n){
        float my_x = a + my_id*h;
        float my_trap = f(my_x);
        atomicAdd(trap_p, my_trap);
    }
}

float trap_wrapper(
    const float a, // Entrada. Limite inferior
    const float b, // Entrada. Limite superior
    const int   blk_ct, // Entrada. Tamanho do grid de processadores
    const int   th_per_blk // Entrada. Threads por por bloco de processadores
    ){
    float *trap_p;
    // Número de divisões (trapézios no intervalo)
    int n = blk_ct*th_per_blk;
    float h = (b-a)/n;
    float result = (1.0/2.0)*(f(a) + f(b));

    cudaMallocManaged(&trap_p, sizeof(float));

    *trap_p = 0;

    Dev_trap<<<blk_ct, th_per_blk>>>(a, h, n, trap_p);
    cudaDeviceSynchronize();

    result = h*(result + (*trap_p));

    cudaFree(trap_p);

    return result;
}

int main(int argc, char ** argv){
    float a, b, result;
    int blk_ct, th_per_blk;

    printf("Informe o limite inferior e superior do intervalo: ");
    if(scanf("%f %f", &a, &b)!=2) return 1;
    printf("Informe o número de blocos e threads por bloco: ");
    if(scanf("%d %d", &blk_ct, &th_per_blk)!=2) return 1;

    result = trap_wrapper(a, b, blk_ct, th_per_blk);

    printf("A aproximação vale: %.2f\n", result);

    return 0;
}