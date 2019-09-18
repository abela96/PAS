#!/bin/bash
#Alejandro Bermudez Lara

if [[ $# -ne 1 ]]; then
	echo "Error en la llamada a ejecucion. La forma correcta es: $0 <nombreArchivo.txt>"
	exit
fi

#Guardo el nombre del archivo
file=$1
temp=$(mktemp)
temp2=$(mktemp)

#Elimina las lineas vacias, los subrayados y lineas que empiezan por espacios, almacenandolos en un fichero temporal
cat $file | sed -r -e '/^$|=|^ /d' > $temp

#Formateo la linea en la que se encuentra la fecha (los dos puntos son el dia, y el mes, el tercer espacio es el anio)
cat $temp | sed -r -e 's/^\((..\/..\/....)\).*/|-> Fecha de estreno: \1/' > $temp2

#Director
cat $temp2 | sed -r -e 's/^Dirigida por (.*)/|-> Director: \1/' > $temp

#Reparto
cat $temp | sed -r -e 's/^Reparto: (.*)/|-> Reparto: \1/' > $temp2

#Duracion
cat $temp2 | sed -r -e 's/^(.hr ..min)/|-> Duración: \1/' > $temp

#Todas las lineas del fichero empiezan ya por "|->" excepto el titulo por lo que busco aquellas que no empiecen asi "[^...]"
cat $temp | sed -r -e 's/(^[^|].*)/Título: \1/' > $temp2

cat $temp2
rm $temp
rm $temp2
