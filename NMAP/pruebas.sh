#!/bin/bash



lineas=`wc -l ip_objetivo | cut -d ' ' -f1`
#echo $lineas
for ((i=1 ; i<=lineas ; i++))
do
	nom=`sed -n "$i"p ip_objetivo`
	msfcli windows/smb/ms08_067_netapi RHOST="$nom" C > "$nom".txt
	echo $nom >> "$nom".txt
done


#RHOST=10.32.73.51
#msfcli windows/smb/ms08_067_netapi RHOST=$RHOST C > escaneo.txt
