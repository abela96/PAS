#!/bin/bash
#Alejandro Bermudez

cat /proc/cpuinfo | sed -r -n -e 's/model name/Modelo de procesador:/p' | uniq

cat /proc/cpuinfo | sed -r -n -e 's/cpu MHz/Megahercios:/p' | uniq

cat /proc/cpuinfo | sed -r -n -e 's/siblings/Numero de hilos maximo de ejecucion:/p' | uniq

cat /proc/cpuinfo | sed -r -n -e 's/processor/Numero de hilos maximo de ejecucion/p'|uniq

cat /proc/cpuinfo | sed -r -n -e 's/cache size/Tamano de cache:/p' | uniq

cat /proc/cpuinfo | sed -r -n -e 's/vendor_id/ID vendedor:/p' | uniq

echo -e "Puntos de montaje:"

cat /proc/mounts | sed -r -n -e 's/^(.*) (\/.*) (.*) r.*/->Punto de montaje: \2, Dispositivo: \1, Tipo de dispositivo: \3/p' | sort -b -k2 -r

echo -e "\nParticiones y numero de bloques: \n"

cat /proc/partitions | sed  -e '1d' | sed -r -n -e 's/^[ ]+[0-9]+[ ]+[0-9]+[ ]+([0-9]+)[ ]+(.*)/-> Partición: \2, Numero Bloques: \1/p' | sort -b -r -k3
