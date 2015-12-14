#!/bin/bash

if [ $# -ne 0 ]
then
echo " "
echo " "

	for (( x = 1 ; x <= $1 ; x++ )); do
		#Tabulacion
		for (( y = $1 ; y >= x  ; y-- )); do
			echo -n " "
		done

		#resta
		for (( z = 1 ; z <= x ; z++ )) ; do
			echo -n "$z"
		done

		#Suma		
		for (( i = 2 ; i <= x ; i++ ));  do
			echo -n "$(($x - $i + 1))"
		done
			echo -n " "
			echo " "
	done
echo " "
echo " "
else
echo "Mete un parametro"
# ./Piramide.sh 5
fi
