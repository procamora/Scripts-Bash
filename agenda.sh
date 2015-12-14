#!/bin/bash

BD=.agendaDB.ods

barra(){
	clear
	echo "############ Agenda # $1 ############" 
	}

cancelar(){
	echo "Operacion cancelada"
	}

pausa(){
	echo " "
	read -n 1 -p "Presiona una tecla para continuar..."
	}

buscar(){
barra "Buscar"
	read -p "Ingrese un nombre:   " nombre
	cat $BD | grep $nombre
	} 

buscar1(){
barra "Buscar"
	read -p "Ingrese un apellido1:   " apellido1
	cat $BD | grep $apellido1
	}

Crear(){ 
barra "Crear"
	echo " "
	read -p "Ingrese un nombre:   " nombre
	read -p "Ingrese un apellido1:   " apellido1
	read -p "Ingrese un telefono: " telefono
	echo "nombre: ${nombre} ; apellido1: $apellido1 ; telefono: $telefono" >> ${BD}
	sort ${BD} > .ordenado
	sort .ordenado > ${BD}
	echo " "
	echo "GUARDADO!"
	}

borrar(){
barra "Borrar"
	read -p "Ingrese un nombre: " nb
	if [ -z $nb ]; then
	cancelar
	else  
	cat $BD | grep -v "${nb}" > ${BD}2 && mv ${BD}2 $BD
	echo " "
	echo "Se ha eiminado el contacto deseado"
	fi
	}  

lista(){
barra "Lista"
	cat $BD
	}

lista1(){
barra "Lista"
	cat $BD | sort -k 2 ${BD}
	}

menu(){
barra "Menu principal"
	echo "#  1.) Busqueda por nombre                      #" 
	echo "#  2.) Busqueda por apellido                    #" 
	echo "#  3.) Crear un nuevo contacto                  #"
	echo "#  4.) Borrar contacto                          #"
	echo "#  5.) Listar por nombre                        #"
	echo "#  6.) Listar por apellido                      #" 
	echo "#  0.) Salir                                    #"
	echo "#################################################"

	read -n 1 -p "    Que desea hacer? " s
	case $s in 
	1) buscar ;;
	2) buscar1 ;;
	3) Crear ;;
	#Borra un contacto poniendo su nombre unicamente
	4) borrar ;;
	#Lista todos los contactos ordenados por nombre alfabeticamente
	5) lista ;;
	#Lista todos los contactos ordenados por apellido alfabeticamente
	6) lista1 ;;
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

#Inicio
menu
