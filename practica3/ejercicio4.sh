#!/bin/bash
#Alejandro Bermudez Lara

#Averiguo el numero de archivos que hay con una profundidad 1, es decir, en el
#directorio actual, teniendo en cuenta solo archivos. Uno la salida de eso a
#wc --lines, que cuenta el numero de lineas para saber cuantos archivos hay.
numeroArchivos=$(find -maxdepth 1 -type f|wc --lines)

echo "El numero de archivos en la carpeta actual es $numeroArchivos"

echo "----------"

listaUsuarios=$(users)

for x in $listaUsuarios
do
	echo $x
done | sort -u
#Ordeno los nombres sin repetirlos con -u de unique

echo "----------"

timeLimit=5

#Establezo un limite de tiempo con el que limito al usuario la respuesta
echo -n "Que caracter quieres contar?"
echo -t $timeLimit caracter

#Si el usuario ha introducido un caracter, lo busco por los directorios
#de manera que los enumero y con tr selecciono solo el elegido destruyendo
#los demas.
if [[ -n $caracter ]]; then
	var=$(find -maxdepth 2 -name "*$caracter*"|tr -cd $caracter|wc --chars)
	echo "El caracter $caracter aparece $var veces en nombres de ficheros o carpetas contenidas en la carpeta actual"
else
	var=$(find -maxdepth 2 -name "*a*"|tr -cd 'a'|wc --chars)
	echo "El caracter <a> aparece $var veces en nombres de ficheros o carpetas contenidas en la carpeta actual"
fi
