# AES-128-for-TEXT-with-Cuda

Description rapide : Ce projet s'inscrit dans le cadre de le cours "Introduction à la sécurité" de ma Licence 3 Informatique à Paris 8. C'est une implémentation d'AES-128 en Cuda pour chiffrer/déchiffrer du texte. Il a été ensuite adapté pour chiffrer/déchiffrer un flux vidéo en temps réel (cf https://github.com/inepsie/AES-128-for-VIDEO-with-Cuda). Au delà de la découverte de l'algorithme AES, le but de ce projet était de progresser en Cuda et de pouvoir réaliser des benchmark de temps d'éxecution afin d'estimer certains facteurs d'optimisations.

Usage : bash aesBenchmark.sh

Le bash va effectuer des benchmarks sur l'implémentation. Ces derniers ont pour but d'évaluer la rapidité en fonction de la taille de la donnée à chiffrer+déchiffrer
et en fonction du nombre de threads par block alloués.

Les données utilisées sont le contenu des fichier "messageX.txt", la taille des fichier étant à chaque fois multipliée par deux.

Les résultats sont écrit au fur et à mesure dans les fichiers "aesTestX" et sont transformés en graphique via gnuplot (graphique : aesTest.png).

Nous pouvons constater que l'augmentation du nombre de threads par bloc jusqu'à 1024 (le maximum sur ma machine) est profitable. Plus le nombre de threads
par bloc est important moins l'augmentation du temps d'exécution est importante pour une m^eme augmentation de taille de donnée.

![Screenshot Particules](./aesBench_0to10.png?raw=true)

