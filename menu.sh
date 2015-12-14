#!/bin/bash
############################################################################
# Copyright 2014 Pablo Rocamora <pablojoserocamora@gmail.com>              #
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


menu1() {
ls
        }


menu2(){
ls
        }

menu3(){
ls
        }


menu4(){
ls
        }


menu5(){
ls
        }


menu(){
barra "Menu principal"
        echo "#  1.) Menu1                                    #"
        echo "#  2.) Menu2                                    #"
        echo "#  3.) Menu3                                    #"
        echo "#  4.) Menu4                                    #"
        echo "#  5.) Menu5                                    #"
        echo "#  0.) Salir                                    #"
        echo "#################################################"

read -n 1 -p "    Que desea hacer? " s
        case $s in
        1) menu1 ;;
        2) menu2 ;;
        3) menu3 ;;
        4) menu4 ;;
        5) menu5 ;;
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
