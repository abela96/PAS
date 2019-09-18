#!/bin/bash
#Alejandro Bermudez Lara

if [[ $# -ne 1 ]]; then
	echo "Error en la llamada a ejecucion. La forma correcta es: $0 <nombreArchivo.txt>"
	exit
fi

echo "===="
echo "Listado de todos los archivos ocultos del directorio $HOME"

ls -Sa $HOME | grep '^\.' > User.txt

cat User.txt | awk '{ print length($0) " " $0; }' | sort -n | cut -d ' ' -f 2-

echo "===="

if [[ -f $1 ]];
then
	echo "El fichero a procesar es $1"
	cat $1 | sed -e '/^$/d' >$1.sinLineasVacias
	echo "El fichero sin lineas vacias se ha guardado en ./$1.sinLineasVacias"

else
	echo "$1 no existe como fichero"
	exit
fi

echo "===="

echo "Listado de los procesos ejecutados por el usuario $USER"

ps aux | awk '$1 ~/'$USER'/' | awk '{ print "{PID:\"" $2 "\" HORA: \"" $9 "\" Ejecutable:\"" $11"\"" }' | sed -n -e '1!p'
