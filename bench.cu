#include "functions.h"

__host__ void initTime(void){
    gettimeofday(&ti, (struct timezone*) 0);
}

__host__ double getTime(void){
    struct timeval t;
    double diff;
    gettimeofday(&t, (struct timezone*) 0);
    diff = (t.tv_sec - ti.tv_sec) * 1000000 + (t.tv_usec - ti.tv_usec);
    return diff/1000.;
}

