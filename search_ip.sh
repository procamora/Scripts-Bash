#!/bin/bash
# Programa que busca direcciones IP en páginas html
if [ $# -lt 1 ]; then
echo "Uso: $0 url"
echo "Ejemplo: $0 www.sitio.com.mx"
exit 1
fi
HTML=/tmp/pagina.html
DOMINIO=`echo $1|cut -d. -f2-5`
wget $1 -O $HTML -o /dev/null
grep "href=" $HTML |grep $DOMINIO |
cut -d/ -f3|grep ${DOMINIO}$|sort -u>/tmp/dir-ip
for i in $(cat /tmp/dir-ip)

do
host $i
done
rm $HTML
