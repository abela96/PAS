#!/bin/bash
#Alejandro Bermudez Lara

if [ $# -lt 1 -o $# -gt 3 ];
then
	echo "Numero de argumentos incorrecto. Ejecucion: $0 <ejemploCarpeta> <umbral1(opcional)> <umbral2(opcional)>"
	exit 1
fi

if ! [[ -d $1 ]];
then
	echo "Error. El primer argumento debe ser un directorio."
	exit 1
fi

if [[ $2 ]];
then
	umbral1=$2
else
	umbral1=10000
fi

if [[ $3 ]];
then
	umbral2=$3
else
	umbral2=100000
fi

#
for dir in pequenos medianos grandes
do
	if [[ -e $dir ]]; then
		echo "Las carpetas de salida $dir ya existe, se va a proceder a borrarlas..."
		rm -r $dir
		mkdir $dir
	else
		echo "Creando las carpetas pequenos, medianos y grandes..."
		mkdir $dir
	fi
done

#Recorre el directorio indicado y comprueba el tamano de cada elemento en el interior
echo "Copiando los archivos..."
if [[ -e $1 ]]; then
	for x in $(find $1 -type f)
	do
		for y in $(stat --format=%s $x)
		do
			if [[ $y -le $umbral1 ]]; then
				cp $x pequenos/
			elif [[ $y -ge $umbral2 ]]; then
				cp $x grandes/
			else
				cp $x medianos/
			fi
		done
	done
else
	echo "Direccion no valida o no existe"
	exit
fi
