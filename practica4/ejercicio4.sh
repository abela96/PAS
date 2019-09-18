#!/bin/bash
#Alejandro Bermudez

if [[ $# -ne 2 ]]; then
	echo "Error en la sintaxis del programa. Sintaxis correcta: $0 <nombreArchivo> <numeroSegundos>"
	exit
fi

while read ip; do
	answerTime=$(ping -c1 $ip -w $2 | grep 'time=.*' -o | sed 's/time=//')
	if [[ "$answerTime" == "" ]]; then
		echo "La IP $ip no respondio tras $2 segundos" >> registroIP.temp
	else
		echo "La IP $ip respondio en $answerTime milisegundos" >> registroIP.tmp
	fi
done < <(cat $1)

cat registroIP.tmp | sort -k6
rm registroIP.tmp
