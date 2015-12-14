#!/bin/bash
#eliminamos tabulaciones, selecionamos solo las lineas que tengan la palabra descargar y la cortamos por la segunda columna que es donde esta la url
sed -i 's/^[ \t]*//;s/[ \t]*$//' index.html | cat index.html | egrep --color=auto 'DESCARGAR<' | awk '{print $2}' > prueba
#elimina href=
sed -i 's/href=//g' prueba
#elimina comillas
sed -i "s/'//g" prueba

wc -l prueba | awk '{print $1}'