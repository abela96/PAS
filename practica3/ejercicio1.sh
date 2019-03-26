#!/bin/bash
#Alejandro Bermúdez Lara

if [[ $# -ne 1 ]];
then
        echo "Error al invocar el programa. Forma correcta: $0 <directorio>"
        exit
fi

fileC=$(find -name "*.c"|wc -l)
fileH=$(find -name "*.h"|wc -l)

echo "Tenemos $fileC ficheros con extension .c y $fileH con extension .h"

for x in $(find $1 -name "*.c" -o -name "*.h")
do
        lineas=$(wc $x -l)
        caracteres=$(wc $x -c)

        echo "El fichero $x tiene $lineas lineas y $caracteres caracteres"
done | sort -nrk5
