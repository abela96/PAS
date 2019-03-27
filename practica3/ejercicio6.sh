#!/bin/bash

#Alejandro Bermudez Lara

#Realizar un script que reciba como argumento el nombre de un directorio y
#genera un fichero .html con el listado de ficheros y/o carpetas de dicho
#directorio. El script debera navegar recursivamente por todas las carpetas
#que haya incluidas en el directorio. Las carpetas deberan representarse en
#negrita, mientras que los ficheros en tipo de texto normal

showHTML()
{
	let depth=1

	echo -e "<ul>" >> "$1.html"

	#Con este bucle iterativo accedo recursivamente a todas y cada una de
	#de las carpetas en el interior de la indicada.
	for i in $(find $2 -maxdepth $depth)
	do
		if [ $i != $2 ]
		then
			if [ -d $i ]
			then
				echo -e "<strong><li>./$i<li></strong>\n" >> "$1.html"

				showHTML $1 $i

				echo -e "</ul>\n">>"$1.html"
			else
				echo -e "<li>./$i</li>\n" >> "$1.html"
			fi
		fi
	done
}

if [ $# -ne 1 ]
then
	echo -n "Usted ha introducido un número erróneo de argumentos -->"
	echo " La sintaxis correcta del programa es: $0 <ejemploCarpeta>"
	exit 1
fi

if [ $# -ge 2 ]
then
	echo "Solo puede especificar un directorio"
	exit 1
fi

if [ -d $1 ]
then
	#Imprimo el valor de un enlace simbolico o el nombre de un archivo. Con
	#el -f persigo todos los enlaces simbolicos de cada componente del
	#archivo dado por el usuario de manera recursivaq
	aux=$(readlink -f "$1")
	echo "Generando el listado de la carpeta $aux sobre el fichero $1.html..."
	echo "¡Terminado!"

	echo -e "<html>\n<head>\n<title>$1</title>\n</head>\n<body>\n<h1>Listado del directorio ./$1/</h1>">>"$1.html"

	showHTML $1 $1

	echo -e "<body><style type="text/css"> body { font-family: sans-serif;} </style>">>"$1.html"
else
	echo "No hemos encontrado el directorio indicado"
	exit 1
fi
