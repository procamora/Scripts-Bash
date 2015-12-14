#!/bin/bash

echo "Introduce un número"
read numero
echo " "
echo " "

for (( x = 1 ; x <= $numero ; x++ ))
do
	for (( y = $numero ; y >= x  ; y-- )); do
		echo -n " "
	done
	
	for (( z = 1 ; z <= x ; z++ )); do
		echo -n "$z"
	done
	
	for (( i = 2 ; i <= x ; i++ )); do
		echo -n "`expr $x - $i + 1`"
	done
	
	echo -n " "
echo " "
done
