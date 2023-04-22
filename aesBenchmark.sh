#!/bin/sh
rm -f aesTest*
make

for((th=0;th<11;++th))
do
    for((i=4;i<10;++i))
    do
        ./aes "message${i}.txt" $th >> aesTest$th
    done
done

gnuplot aesBench.plot
gimp aesTest.png
