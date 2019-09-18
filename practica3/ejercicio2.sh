#!/bin/bash

#Alejandro Bermudez Lara

#Me aseguro de que el numero de argumentos es el correcto pedido por el ejercicio
#No podra ser mayor de 2 o menor de 1. Si no se introducen los argumentos correctos,
#se indica como hacerlo
if [ $# -lt  1 -o $# -gt 2 ];
then
	echo "La sintaxis correcta para ejecutar este programa es: \> $0 <ejemploCarpeta> <numeroBytes(Opcional)>"
	exit 1
fi

<<COMMENT
Con la opcion -d compruebo que el argumento pasado por teclado sea un directorio
-e seria para comprobar si $1 existe, -s seria para comprobar que $1 tiene un
tamanio mayor que cero, -f si es un fichero normal, -l si $1 es un enlace simbolico
-r si se tienen permisos de lectura, -w si se tienen permisos de escritura
-x si se tienen permisos de ejecucion
COMMENT
if ! [ -d "$1" ];
then
	echo "Incorrecto, el primer valor debe ser un directorio"
	exit 1
fi

#En caso de que no se pase el numero de bytes
#Asigno a la varaible contenido todo el contenido del directorio
if [[ $# -eq 1 ]];
then
	CONTENIDO=$(find $1)
fi

<<COMMENT
#Asigno a CONTENIDO todos los archivos de mayor o igual tamanio que el argumento $2
COMMENT
if [[ $# -eq 2 ]];
then
	CONTENIDO=$(find $1 -size +"$2")
fi


echo "Nombre, LongitudUsuario, FechaModificacion, FechaAcceso, Tamano, Bloques, Permisos, Ejecutable"

<<COMMENT
#Recorro la variable CONTENIDO con una bucle iterativo en el que extraigo el
nombre del fichero sin la ruta con $basename, el numero de caracteres del nombre
de usuario del propietario con stat y luego una tuberia para contar el numero de
caracteres. Para averiguar la fecha de ultima modificacion, el ultimo acceso al
al fichero, el tamanio en bytes y numero de bloques que ocupa en memoria, asi como
la cadena de permisos que ocupa en memoria con $y, %X, %s, %b, %A respectivamente
COMMENT
for x in $CONTENIDO
do
	echo -n $(basename $x)
	echo -n ";"
	echo -n $(stat --format=%U $x|wc --chars)
	echo -n ";"
	echo -n $(stat --format=%y\;%X\;%s\;%b\;%A $x)
	echo -n ";"


	if [[ -x $x ]];
	then
		echo 1
	else
		echo 0
	fi
done | sort -n -b -k5 --field-separator=";"

#Ordeno segun el valor de la quinta fila y selecciona como separadores el simbolo ;
