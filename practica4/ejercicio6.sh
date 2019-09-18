#!/bin/bash
#Alejandro Bermudez Lara

#Compruebo que se pasa un argumento
if [[ $# -ne 1 ]]; then
	echo "Ejecucion incorrecta. Sintaxis correcta: $0 <cadenaTexto>"
	exit
fi

rm usuarios.txt

#Compruebo la opcion es correcta
who | cut -f1 -d " " > usuarios.txt

while read linea
do
	logged=0
	gUI=$(echo "$linea" | cut -f7 -d :)
	UI=$(echo "$linea" | cut -f1 -d :)

	if [[ "$gUI" = "$1" ]]; then
		echo "$linea" | sed -rne "s/(.*):(.*):(.*):(.*):(.*):(.*):(.*)/==========\nLogname: \1 \n->UID: \3 \n->GID: \4 \n->gecos: \5 \n->Home: \6 \n->Shell por defecto: \7./p"

		while read linea
		do
			gUIs=$(echo "$linea" | cut -f1 -d " ")
			if [ "$gUIs" = "$UI" ]
			then
				loge=1
			fi
		done < ./usuarios.txt

		echo "|->logeado : $loge "
	fi

done < /etc/passwd #Procedo a leer el fichero
