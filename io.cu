#include "functions.h"

__host__ FILE * ouvrirWb(char * nom){
    FILE * f = NULL;
    f = fopen(nom, "wb");
    assert(f);
    return f;
}

__host__ FILE * ouvrirRb(char * nom){
      FILE * f = NULL;
      f = fopen(nom, "rb");
      assert(f);
      return f;
}

__host__ int fileLen(char * filename){
    int len;
    FILE * fd = ouvrirRb(filename);
    assert(fd);
    fseek(fd,0,SEEK_END);
    len = ftell(fd);
    fclose(fd);
    return len;
}

__host__ void loadDataFromF(char * filename, INTTYPE ** data, int fd_len){
    FILE * fd = ouvrirRb(filename);
    assert(fd);
    unsigned char * tmp = (unsigned char*) malloc(fd_len * sizeof *tmp);
    fread(tmp, 1, fd_len, fd);
    for(int i=0 ; i<fd_len ; ++i){
	    //printf("%d|", (unsigned int)tmp[i]);
	   (*data)[i] = (unsigned int) tmp[i];
    } 
    fclose(fd);
    //printf("\nFIN LoadDataFromF\n");
}
