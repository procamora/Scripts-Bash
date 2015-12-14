#!/bin/bash

# Aplicar la regla de filtrado para bloqueo de la direccion IP
echo -n "Ingrese la direccion IP a bloquear"

# Entrada por teclado de la direccion IP a bloquear
read ip

# Cadena de bloqueo de la direccion IP
iptables -A INPUT -s $ip -j DROP

# Se guarda la nueva regla
service iptables save

# Se reinica el servicio iptables
service iptables restart
