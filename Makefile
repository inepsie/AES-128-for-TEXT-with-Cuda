
all:
	nvcc *.cu -o aes

clean: 
	rm -rf *.o core
	rm -f core
	rm -rf *~
	rm -rf aes
run:
	./aes
