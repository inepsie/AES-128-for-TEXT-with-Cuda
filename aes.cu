#include "functions.h"

__host__ int blocksPG(int fd_len, int threadsPerBlock){
	return (fd_len + threadsPerBlock - 1) / threadsPerBlock; 
}

__host__ INTTYPE rotWord(INTTYPE w){
	INTTYPE tmp;
	tmp = w & (255<<24);
	w = w << 8;
	w = w | tmp;
	return w;
}

__host__ INTTYPE subWord(INTTYPE w, INTTYPE * sb){
	INTTYPE res = 0;
	INTTYPE tmp;
	for(int i=0 ; i<4 ; ++i){
		tmp = w >> (8*(3-i));//On prend chacun des octets de tmp (de la gauche vers la droite).
		tmp = tmp & 255;
		tmp = sb[tmp];//On transforme ces octets via la sbox.
		res = res << (8*i) + tmp;//On construit le résultat en plaçant les nouveaux octets les uns à la suite des autres.
	}
	return res;
}

__host__ void keyExpansion(INTTYPE ** key_exp, INTTYPE * sb){
	int w;
	INTTYPE * key_word = (INTTYPE *) malloc(11 * 4 * sizeof(*key_word));//On crée 11 clés formées de 4 mots de 32bits.
	INTTYPE r[10] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36};
	for(int i=0 ; i<4 ; ++i){
		key_word[i] = (INTTYPE) rand();
	}
	for(int i=4 ; i<(NBKEY-1)*4 ; ++i){
		key_word[i] = key_word[i-1];
		if(!(i%4)){
			key_word[i] = subWord(rotWord(key_word[i]), sb)  ^ r[i/4];	
		}
		key_word[i] ^= key_word[i-4];
	}
	for(int i=0 ; i<11 ; ++i){//On divise les clés crées dans des espaces de 8bits
		for(int j=0 ; j<4 ; ++j){
			w = key_word[i*4+j];//On prend chacun des mots de 32bits pour les diviser en 4;
			for(int h=0 ; h<4 ; ++h){
				(*key_exp)[i*16+j*4+h] = (w >> (3-h)) & 255;
			}
		}
	}
	free(key_word);
}

__host__ void encryption(INTTYPE ** d_data, INTTYPE ** d_out, INTTYPE * d_key, int threadsPerBlock, int blocksPerGrid){
	for(int i=0 ; i<NBKEY ; ++i){
		aesXor <<<blocksPerGrid, threadsPerBlock>>>(*d_data, d_key, i, *d_out);
		sbox <<<blocksPerGrid, threadsPerBlock>>>(*d_out, *d_data);
		shiftRows <<<blocksPerGrid, threadsPerBlock>>>(*d_data, *d_out);
		mixColumns <<<blocksPerGrid, threadsPerBlock>>>(*d_out, *d_data);
	}
}


__host__ void decryption(INTTYPE ** d_data, INTTYPE ** d_out, INTTYPE * d_key, int threadsPerBlock, int blocksPerGrid){
	for(int i=0 ; i<NBKEY ; ++i){
		inv_mixColumns <<<blocksPerGrid, threadsPerBlock>>>(*d_data, *d_out);
		inv_shiftRows <<<blocksPerGrid, threadsPerBlock>>>(*d_out, *d_data);
		inv_sbox <<<blocksPerGrid, threadsPerBlock>>>(*d_data, *d_out);
		aesXor <<<blocksPerGrid, threadsPerBlock>>>(*d_out, d_key, NBKEY-1-i, *d_data);
	}
}

