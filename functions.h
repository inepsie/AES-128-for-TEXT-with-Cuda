#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <sys/time.h>
#include <limits.h>

#define MATBLOCK 16
#define LENKEY 128
#define NBOCTKEY 16
#define NBKEY 11
typedef unsigned char INTTYPE;
static struct timeval ti;

// "kernels.cu"
__global__ void aesXor(INTTYPE * a, INTTYPE * k, INTTYPE ind, INTTYPE * b);
__global__ void sbox(INTTYPE * a, INTTYPE * b);
__global__ void inv_sbox(INTTYPE * a, INTTYPE *b);
__global__ void shiftRows(INTTYPE * a, INTTYPE *b);
__global__ void inv_shiftRows(INTTYPE * a, INTTYPE * b);
__global__ void mixCol(INTTYPE * a, INTTYPE * b);
__global__ void mixColumns(INTTYPE * a, INTTYPE * b);
__global__ void inv_mixColumns(INTTYPE * a, INTTYPE * b);

// "bench.cu"
__host__ void initTime(void);
__host__ double getTime(void);

// "io.cu"
__host__ FILE * ouvrirWb(char * nom);
__host__ FILE * ouvrirRb(char * nom);
__host__ int fileLen(char * filename);
__host__ void loadDataFromF(char * filename, INTTYPE ** data, int fd_len);

// "verify.cu"
// (cpu functions to verify kernels results)
__host__ void verify_res(INTTYPE * start, INTTYPE *end, int n);
__host__ int verify_xor(INTTYPE * data, INTTYPE * key, INTTYPE ind, INTTYPE * out, int fd_len);
__host__ int verify_sbox(INTTYPE * data, INTTYPE * sb, INTTYPE * out, int fd_len);
__host__ int verify_shiftRows(INTTYPE * data, INTTYPE * shift_rows_b, INTTYPE * out, int fd_len);
__host__ int verify_mixColumns(INTTYPE * data, INTTYPE * out, int fd_len);
__host__ int verify_inv_mixColumns(INTTYPE * data, INTTYPE * out, int fd_len);

// "aes.cu"
// (cpu functions to do some main aes tasks)
__host__ int blocksPG(int fd_len, int threadsPerBlock);
__host__ INTTYPE rotWord(INTTYPE w);
__host__ INTTYPE subWord(INTTYPE w, INTTYPE * sb);
__host__ void keyExpansion(INTTYPE ** key_exp, INTTYPE * sb);
__host__ void encryption(INTTYPE ** d_data, INTTYPE ** d_out, INTTYPE * d_key, int threadsPerBlock, int blocksPerGrid);
__host__ void decryption(INTTYPE ** d_data, INTTYPE ** d_out, INTTYPE * d_key, int threadsPerBlock, int blocksPerGrid);
