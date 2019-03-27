#!/bin/bash

#Alejandro Bermudez Lara

#Compruebo que el usuario nos proporcione al menos una direccion
if [ $1 ]
then
	#Si el usuario proporciona umbral1, lo asigno a n, en su defecto
	#n seria igual 10000 tal y como indica el problema
	if [ $2 ];
	then
		n=$2
	else
		n=10000
	fi

	#Si el usuario proporciona umbral2, lo asigno a n, en su defecto
	#n seria igual 100000 tal y como indica el problema
	if [ $3 ];
	then
		m=$3
	else
		m=100000
	fi

	echo "Creando las carpetas pequenos, medianos y grandes..."
	#Compruebo que no exista previamente una carpeta con el nombre pequeno
	if [ -d ./pequeno ]
 	then
		rm -r pequeno
		mkdir pequeno]
	else
		mkdir pequeno
	fi
	#Compruebo que no exista previamente una carpeta con el nombre mediano
	if [ -d ./mediano ]
 	then
		rm -r mediano
		mkdir mediano
	else
		mkdir mediano
	fi
	#Compruebo que no exista previamente una carpeta con el nombre grande
	if [ -d ./grande ]
 	then
		rm -r grande
		mkdir grande
	else
		mkdir grande
	fi
		echo "Copiando los archivos..."
		#Recorro todos y cada uno de los elementos que se encuentran
		#dentro de la carpeta que se me ha pasado por terminal
		for x in $(find $1 )
		do
			#Recorro los directorios y archivos que puedan
			#encontrarse en el que me ha pasado el usuario
			#calculando su tamanio
			for y in $(stat -c " %s  " $x)
			do
				#Si el elemento es menor que el umbral1
				if [ $y -lt $n ];
				then
					cp $x  pequeno/
				#Si el elemento es mayor que el umbral2
				elif [ $y -gt $m ]
				then
					cp $x grande/
				else
				#En el caso de que los elementos esten entre
				#el umbral1 y el umbral2 los coloco en la
				#la carpeta mediano
					cp $x mediano/
				fi
			done
		done
else
	echo "No hay direccion, por favor introduzca una"
	exit

fi
