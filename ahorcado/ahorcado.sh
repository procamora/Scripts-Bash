#!/bin/bash

function message() {
    case $mensage in
	game_banner)	#tput cup 1 $cols
			echo
			tput rev
			echo "$(tput setaf 4)EL JUEGO DEL AHORCADO EN BASH SCRIPT$(tput sgr0)"
			echo
			echo "$(tput setaf 7)$(tput bold)Contiene $(tput setaf 1)$(( $long_palabra-$espacios ))$(tput setaf 7) caracteres sin contar los espacios"
			echo "$(tput setaf 7)Puedes usar los comodines. Dispones de $(tput setaf 1)$comodines$(tput setaf 7). Para usarlos pulsa $(tput setaf 1)+"
			[[ $(( 6-intentos )) -lt 2 ]] && vida="vida" || vida="vidas"
			echo "$(tput setaf 7)Dispones de $(tput setaf 1)$(( 6-intentos )) $vida"
			#echo "$(tput setaf 7)El nombre de este país es $(tput setaf 1)$palabra"¡
			echo
			echo "$(tput setaf 7)El nombre de este país es: $(tput setaf 1)$word"
			echo -n "$(tput setaf 7)Vidas: $(tput setaf 1)"
			for (( i=1; i<=$(( 6-intentos )); i++ )); do echo -n $'\342\231\245'; done; echo
			echo -n "$(tput setaf 7)Comodines: $(tput setaf 1)"
			for (( i=1; i<=$comodines; i++ )); do echo -n $'\342\230\245'; done; echo
			echo "$(tput setaf 7)Caracteres restantes: $(tput setaf 1)$(( ($long_palabra-$espacios)-$aciertos ))"
			echo "$(tput setaf 7)Puntuación: $(tput setaf 1)$score";;
	game_over) 	echo "$(tput setaf 2)Fenomenal, eres un crack";;
	game_read)	read -n1 -p "$(tput setaf 7)Vida $(tput setaf 1)$intentos $(tput setaf 7)de $(tput setaf 1)5$(tput setaf 7). Introduce una letra: $(tput setaf 1)" caracter
			echo;;
	salir)		echo
			tput rev
			echo "$(tput setaf 1)GameOver$(tput sgr0)"
			echo "$(tput setaf 7)$(tput bold)Tu mejor puntuación es: $(tput setaf 1)$best_score"
			echo "$(tput setaf 7)Tu puntuación acumulada es: $(tput setaf 1)$acumulado"
			echo
			echo "$(tput setaf 7)Que deseas hacer?"
			read -n1 -p "$(tput setaf 7)Pulsa $(tput setaf 1)Q $(tput setaf 7)para $(tput setaf 1)salir $(tput setaf 7)o $(tput setaf 1)G $(tput setaf 7)para $(tput setaf 1)volver a jugar$(tput setaf 7). Introduce una letra: $(tput setaf 1)" caracter
			echo "$(tput setaf 7)";;
	comodines_restantes)	echo "$(tput setaf 4)Te dispones a usar un comodín. Suerte, sólo dispones de $(tput setaf 1)$comodines"
				echo "$(tput setaf 2)Comodín = $(tput setaf 1)$caracter";;
	comodines_finalizados)	echo "$(tput setaf 4)Ups, has gastado todos los comodines";;
	continuar)	read -n1 -p "$(tput setaf 1)Pulsar cualquier tecla para continuar$(tput setaf 7)";;
	acierto_mal)	echo "$(tput setaf 4)Has fallado, ahora tienes un intento menos";;
	#acierto_letra)	echo "$(tput setaf 7)Letra introducida: $(tput setaf 1)$letra";;
	acierto_bien)	echo "$(tput setaf 2)Muy bien, ya casi lo tienes";;
	acierto_repetido)	echo "$(tput setaf 3)Upps, Esa letra ya la has introducido";;
    esac
}
function init {
#file="diccionario"
    file="paises"
    max=$(cat $file | wc -l)
    num=$(( $RANDOM%$max ))
    palabra=$(head -$num $file | tail -1)
    aciertos=0
    #diccionario
    #palabra=$(echo ${palabra%% *,,} | sed 's/á/a/g;s/é/e/g;s/í/i/g;s/ó/o/g;s/ú/u/g')

    palabra=$(echo ${palabra,,} | sed 's/á/a/g;s/é/e/g;s/í/i/g;s/ó/o/g;s/ú/u/g;s/-/ /g;s/Á/a/g')
    long_palabra=${#palabra}
    comodines=$(( long_palabra/4 ))
    score=$(( (comodines*50)+500 ))
    #PROVISIONAL
    ###########################
    #[[ $long_palabra -lt 15 ]] && main;
    ###########################
    unset array[*]
    i=0; espacios=0; unset word
    while [[ $i -le $(( $long_palabra-1 )) ]]
	do
	    caracter="${palabra:$i:1}"
	    if [[ $caracter = " "  ]]
		then
		    (( espacios++ ))
		    caracter=" "
		else
		    array=( ${array[*]} $caracter )
		    caracter="-"
	    fi
	    word="$word $caracter"
	    (( i++ ))
    done
}

function comodin {
    if [[ $comodines -gt 0 ]]
	then
	    long_array=$(( ${#array[*]}-1 ))
	    index=$(( $RANDOM%${#array[*]} ))
	    caracter=${array[$index]}
	    i=0
	    while [[ $i -le $long_array ]]
		do
		    if [[ ${array[$i]} = $caracter ]]
			then
			    unset array[$i]
			    array2=( ${array2[*]} $caracter )
			    (( aciertos++ ))
			    score=$(( score+50 ))
		    fi
		    (( i++ ))
	    done
	    array=( ${array[*]} )
	    array2=( ${array2[*]} )
	    (( comodines-- ))
	    (( intentos-- ))
	    mensage="comodines_restantes"; message mensage
    else
	(( intentos-- ))
	mensage="comodines_finalizados"; message mensage
    fi
    mensage="continuar"; message mensage
    game
}

function acierto {
    unset find
    long_array=$(( ${#array[*]}-1 ))
    i=0
    while [[ $i -le $long_array ]]
	do
	    if [[ ${array[$i]} = $caracter ]]
		then
		    unset array[$i]
		    find="true"
		    array2=( ${array2[*]} $caracter )
		    (( aciertos++ ))
		    score=$(( score+100 ))
	    fi
	    (( i++ ))
    done
    if [[ $find = "true" ]]
	then
	    mensage="acierto_bien"; message mensage
	    (( intentos-- ))
	else
	    long_array2=$(( ${#array2[*]}-1 ))
	    i=0
	    while [[ $i -le $long_array2 ]]
		do
		    if [[ ${array2[$i]} = $caracter ]]
			then
			    find="true"
		    fi
		    (( i++ ))
	    done
	    if [[ $find = "true" ]]
		then
		    mensage="acierto_repetido"; message mensage
		    (( intentos-- ))
		    score=$(( score-10 ))
		else
		    mensage="acierto_mal"; message mensage
		    score=$(( score-50 ))
	    fi
    fi
    array=( ${array[*]} )
    array2=( ${array2[*]} )
    mensage="continuar"; message mensage
    game
}
function game {
    clear
    lines=$(( $(tput lines)/10 ))
    cols=$(( $(tput cols)/10 ))
    i=0; unset word;
    while [[ $i -le $(( $long_palabra-1 )) ]]
	do
	    letra="${palabra:$i:1}"
	    if [[ $letra = " "  ]]
		then
		    letra=" "
		else
		    unset letra_acertada
		    for x in ${array2[*]}
			do
			    if [[ $x = $letra ]]
				then
				    letra_acertada="true"
			    fi
		    done
		    if [[ $letra_acertada != "true" ]]
			then
			    letra="-"
		    fi
	    fi
	    word="$word $letra"
	    (( i++ ))
    done
    (( intentos++ ))
    mensage="game_banner"; message mensage
    dibujo
    if [[ $intentos -gt 5 ]]
	then
	    [[ $best_score -eq 0 ]] && best_score=0
	    [[ $acumulado -eq 0 ]] && acumulado=0
	    salir
    fi

    if [[ -z ${array[*]} ]]
	then
	    [[ $score -gt $best_score ]] && best_score=$score
	    acumulado=$(( acumulado+score ))
	    mensage="game_over"; message mensage
	    salir
    fi
    mensage="game_read"; message mensage
    if [[ $caracter = "+" ]]
	then
	    comodin
    fi
    acierto
}

function dibujo {
    case $intentos in
	1)	echo "________ "
		echo "|/      | "
		echo "|       O "
		echo "|         "
		echo "|         "
		echo;;
	2)	echo "________ "
		echo "|/      | "
		echo "|       O "
		echo "|       | "
		echo "|       | "
		echo "|         "
		echo;;
	3)	echo "________ "
		echo "|/      | "
		echo "|       O "
		echo "|      \| "
		echo "|       | "
		echo "|         "
		echo;;
	4)	echo "________ "
		echo "|/      | "
		echo "|       O "
		echo "|      \|/"
		echo "|       | "
		echo "|         "
		echo;;
	5)	echo "________ "
		echo "|/      | "
		echo "|       O "
		echo "|      \|/"
		echo "|       | "
		echo "|      /  "
		echo "|         "
		echo;;
	*)	echo "________ "
		echo "|/      | "
		echo "|       O "
		echo "|      \|/"
		echo "|       | "
		echo "|      / \\"
		echo "|        "
		echo "La palabra era $palabra"
		echo;;
    esac
}
function salir {
    mensage="salir"; message mensage
    case $caracter in
	q)	clear;exit;;
	g)	unset word; unset intentos; unset comodines; unset aciertos; unset score; unset array[*]; unset array2[*];main;;
	*)	clear; mensage="game_banner"; message mensage; dibujo; salir;;
    esac
    clear
}

function main {
    init
    game
}
main
