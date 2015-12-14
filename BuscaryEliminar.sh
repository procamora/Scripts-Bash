#!/bin/bash
#importante el comando xargs. busca y elimina los directorios, no hay problema si tiene esacio la ruta
find /media/HDD/Descargas/ -name "*PublicHD*" | xargs -d "\n" rm -r