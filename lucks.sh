#!/bin/bash

echo "introduce la ruta del disco:"
read disco
echo "introduce el nombre del disco:"
read nombre
echo "introduce el formato a formatear (mkfs.ext4/mkfs.ntfs/mkfs.vfat):"
read formato

echo "Has introducido los siguientes datos:" $disco $nombre $formato
echo "Si son correctos los datos pulsa 1)"
read confirm

if [ "$confirm" -eq 1 ]; then
	echo "# cryptsetup --verbose --verify-passphrase luksFormat $disco"
	echo "#####################################################"
	cryptsetup --verbose --verify-passphrase luksFormat $disco
	echo "# cryptsetup luksOpen $disco $nombre"
	echo "#####################################################"
	cryptsetup luksOpen $disco $nombre
	echo "# cryptsetup luksOpen $disco $nombre"
	echo "#####################################################"
	$formato -L "$nombre" /dev/mapper/$nombre
	echo "#####################################################"

	#mkdir /media/$nombre
	#mount /dev/mapper/$nombre /media/$nombre
	echo "#####################################################"

else
	echo "cancelado"
fi
