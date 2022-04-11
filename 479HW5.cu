#include <stdio.h>
#include <cuda.h>
//kernel to initialize array with all zeros
__global__ void dkernel(unsigned *array, int size) { 
  unsigned id = blockIdx.x * blockDim.x + threadIdx.x; 
  if (id < size)  array[id] = 0; 
} 
//kernel to initialize array[i] = i
__global__ void bkernel(unsigned *array, int size) {
    unsigned id = blockIdx.x *blockDim.x + threadIdx.x;
    if (id < size) {
        array[id] = id;
    }
}
#define BLOCKSIZE 1024 
int main(void) { 
    //problem 1
    //Initializing an array of size 32 to all zeros in parallel.
    unsigned size = 32;
    unsigned *arr, *harr;
    cudaMalloc(&arr, size * sizeof(unsigned));
    harr = (unsigned *)malloc(size * sizeof(unsigned)); 
    unsigned nblocks = ceil((float) size / BLOCKSIZE); 
    printf("Created array size %d and filled with 0.\n", size); 
    dkernel<<<nblocks, BLOCKSIZE>>>(arr, size);
    cudaMemcpy(harr, arr, size * sizeof(unsigned), cudaMemcpyDeviceToHost);
    //For loop used to print array in order to checking contents
    /*for (unsigned ii = 0; ii < size; ++ii) 
    { 
        printf("%4d ", harr[ii]); 
    } */

    //problem 2
    //changing the size of the array to 1024
    size = 1024;
    cudaMalloc(&arr, size * sizeof(unsigned));
    harr = (unsigned *)malloc(size * sizeof(unsigned)); 
    nblocks = ceil((float) size / BLOCKSIZE); 
    printf("Created array size %d and filled with 0.\n", size); 
    dkernel<<<nblocks, BLOCKSIZE>>>(arr, size);
    cudaMemcpy(harr, arr, size * sizeof(unsigned), cudaMemcpyDeviceToHost); 
    //problem 3
    //using another kernel to add i to array[i]
    bkernel<<<nblocks, BLOCKSIZE>>>(arr, size);
    cudaMemcpy(harr, arr, size * sizeof(unsigned), cudaMemcpyDeviceToHost); 
    printf("Created array size %d and filled with array[i] = i.\n", size); 
    //For loop used to print array in order to checking contents
    /* for (unsigned ii = 0; ii < size; ++ii) { 
        printf("%4d ", harr[ii]); 
    } */

    //problem 4
    //changing the array to size 8000 and adding i to array[i]
    size = 8000;
    cudaMalloc(&arr, size * sizeof(unsigned));
    harr = (unsigned *)malloc(size * sizeof(unsigned)); 
    nblocks = ceil((float) size / BLOCKSIZE); 
    printf("Created array size %d and filled with array[i] = i.\n", size); 
    bkernel<<<nblocks, BLOCKSIZE>>>(arr, size);
    cudaMemcpy(harr, arr, size * sizeof(unsigned), cudaMemcpyDeviceToHost); 
    //For loop used to print array in order to checking contents
    /* for (unsigned ii = 0; ii < size; ++ii) 
    { 
        printf("%4d ", harr[ii]); 
    } */
} 