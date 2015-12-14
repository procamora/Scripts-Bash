#!/bin/bash
for dom in $(cat dominios.txt); do sh dig.sh $dom; done # para buscar en un fichero de texto

digcmd=$(which dig)
domain=$1
echo -n "[+] Getting NS domains from $1 ..."
ns_domains=$(dig NS $domain @4.2.2.2|grep ^$domain|awk {'print $5'}|sed 's/.$//g')
echo -e "\t[OK]"
for ns in $ns_domains; do echo "[-] Found: "$ns; done
  for ns in $ns_domains
  do
    echo -n "Trying Zone Transfer from $ns: "
    $digcmd AXFR $domain @$ns|egrep 'Transfer failed|timed out|end of file'>/dev/null
    if [ $? -eq 1 ]
       then
       echo -e "\tSuccess."
     else
       echo -e "\tFallo."
    fi
done
