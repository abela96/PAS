#!/bin/bash
#Alejandro Bermudez Lara

muestraHTML()
{
	let depth=1

	echo -e "<ul>" >> "$1.html"

	#Con este bucle iterativo accedo de forma recursiva a todas las carpetas en el interior de la pasada por terminal
	for i in $(find $2 -maxdepth $depth)
	do
		if [[ $i != $2 ]]; then
			if [[ -d $i ]]; then
				echo -e "<strong><li>./$i<li></strong>\n" >> "$1.html"
				muestraHTML $1 $i
				echo -e "</ul>\n">>"$1.html"
			else
				echo -e "<li>./$i</li>\n" >> "$1.html"
			fi
		fi
	done
}

if [[ $# -ne 1 ]]; then
	echo -n "Has introducido un numero erroneo de argumentos"
	echo "Ejecucion correcta: $0 <ejemploCarpeta>"
	exit 1
fi

if [[ $# -ge 2 ]]; then
	echo "Solo se puede especificar un directorio"
	exit 1
fi

if [[ -d $1 ]]; then
	#Imprimo el valor de un enlace simbolico o el nombre de un archivo. Con
	#el -f persigo todos los enlaces simbolicos de cada componente del
	#archivo dado por el usuario de manera recursiva
	aux=$(readlink -f "$1")
	echo "Generando el listado de la carpeta $aux sobre el fichero $1.html"
	echo "Terminado!"

	echo -e "<html>\n<head>\n<title>$1</title>\n</head>\n<body>\n<h1>Listado del directorio ./$1/</h1>">>"$1.html"

	muestraHTML $1 $1

	echo -e "<body><style type="text/css"> body { font-family: sans-serif;} </style>">>"$1.html"
else
	echo "No hemos encontrado el directorio indicado"
	exit 1
fi
