#!/bin/bash

#Alejandro Bermudez Lara

#Script que aplique una copia de seguridad de ficheros o directorios
#Todos los ficheros o directorios que se pasen por argumento
#se comprimiran juntos en un unico fichero copia-usuario-fecha.tar.gz
#Una vez comprimidos, los archivos se mover ́an a la carpeta  ̃ /Copia

#Comprobacion de errores
if [ $# -lt 1 ]
then

	echo "Error en la llamada a la ejecución. Sintaxis correcta: ./ejercicio4.sh <directorio/fichero>"
	exit 1

fi

#Obtengo la fecha actual en segundos desde el 1 de enero de 1970
currentDate=$(date +%s)

#Creo el nombre de la copia de seguridad
fileName="copia-$USER-$currentDate.tar.gz"

#Comprimo todos los archivos o directorios pasados por terminal
tar -cf $fileName $*

#Compruebo si ya existe la copia de seguridad
if [ ! -e ~/Copia ];
then

	mkdir ~/Copia

fi

#Muevo la copia de seguridad a la carpeta Copia
mv $fileName ~/Copia

#Realizo comprobación de la creación de la copia de seguridad
if [ -e ~/Copia/$fileName ];
then

	echo "Copia de seguridad creada correctamente"

fi

#Recorro los archivos de la carpeta Copia
for x in $(find ~/Copia)
do
		#fecha de la ultima modificacion en segundos desde el 1 de enero de 1970 (para poder restar las dos fechas sin problema)
		fechaModificacion=$(stat -c %Y $x)
		diferencia=$(($currentDate-$fechaModificacion))

		#si la diferencia entre la fecha actual y la fecha de su ultima modificación es superior a 200 segundos, se elimina
		if [ $diferencia -gt 200 ];
		then

			rm $x

			#Compruebo que no ha habido problemas en el proceso de borrado
			if [ ! -e $x ];
			then
				echo "La copia de seguridad $x se ha borrado correctamente"
			fi

		fi

done
