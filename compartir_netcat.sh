#!/bin/bash
#ejemplo de usp: ./compartir_netcat.sh /home/rocky/ejemplo

nc -w 5 -l -p 555 < $1
