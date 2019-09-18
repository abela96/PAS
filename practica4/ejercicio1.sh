#!/bin/bash
#Alejandro Bermudez Lara

if [[ $# -ne 1 ]]; then
	echo "Numero incorrecto de argumentos"
	echo "La sintaxis correcta es: $0 <fichero.txt>"
	exit
else
	#Muestro aquellas lineas que contienen la duracion de la pelicula
	echo '*******'
	echo "1) Lineas con la duracion de las peliculas:"
	cat $1 | grep -E '[1-9hr]*\ [1-9]*\min\.*'

	#Mostrar aquellas lineas que contienen el pais de la pelicula
	echo '*******'
	echo "2) Lineas con el pais de las peliculas:"
	cat $1 | grep -E '\-\-*'

	#Similar al ejercicio anterior, pero mostrar solo los paises
	echo '*******'
	echo "3) Solo el pais de las peliculas:"
	cat $1 | grep -E -o '\-.*\-+'

	#Contar cuantas peliculas son del 2016 y cuantas del 2017
	echo '*******'
	p2016=$(cat $1 | grep -E -o -c '(2016)')
	p2017=$(cat $1 | grep -E -o -c '(2017)')
	echo "4) Hay $p2016 peliculas del 2016 y $p2017 peliculas del 2017"

	#Eliminar lineas vacias:
	echo "*******"
	cat $1 | grep -E '.'

	#Mostrar aquellas lineas que empiezan por la letra E (haya o no espacios antes de la misma)
	echo "*******"
	echo "6) Lineas que empiezan por la letra E (con o sin espacios antes):"
	cat $1 | grep -E '^\ *[E]'

	#Mostrar aquellas lineas que contengan una letra d, l o t, una vocal y la misma letra
	echo "*******"
	echo "7) Lineas que contienen d, l o t, una vocal y la misma letra:"
	cat $1 | grep -E '([dlt])[aeiou]\1'

	#Todas aquellas lineas que tengan, en total, 8 vocales aes o mas
	echo "*******"
	echo "8) Lineas que contienen 8 aes o mas:"
	cat $1 | grep -E '(.*a.*){8,}'

	#Mostrar aquellas lineas que terminan con tres puntos (“...”) y no empiezan por espacio
	echo "*******"
	echo "9) Lineas que terminan con tres puntos y no empiezan por espacio:"
	cat $1 | grep -E '^[[:alnum:]].*[.]{3,}$'

	#Utilizar sed para mostrar, entre comillas dobles, las vocales con tilde (mayusculas o minusculas)
	echo "*******"
	echo "10) Mostrar entre comillas las vocales con tildes:"
	cat $1 | -r -e 's/([ÁÉÍÓÚáéíóú])/"\1"/g'
fi
