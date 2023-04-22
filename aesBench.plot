set terminal png
set output "aesTest.png"

set xlabel "Taille de la donnée en octet"
set ylabel "Temps d'execution en millisecondes"

set autoscale

set title "Tests sur les variations  de nombre de threads"

set style data linespoints


plot "aesTest5" using 1:2 title "32 thread par bloc", \
    "aesTest6" using 1:2 title "64 thread par bloc", \
    "aesTest7" using 1:2 title "128 thread par bloc", \
    "aesTest8" using 1:2 title "256 thread par bloc", \
    "aesTest9" using 1:2 title "512 thread par bloc", \
    "aesTest10" using 1:2 title "1024 thread par bloc"
