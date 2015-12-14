#!/bin/bash

echo "Introduce un número"
read numero
for i in `seq 1 $numero`
do
	for j in `seq $i $numero`
	do
		echo -n " "
	done
	for n in `seq 1 $i`
	do
	echo -n "$i "
	done
echo " "
done
