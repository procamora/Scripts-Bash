#!/bin/bash

is_alive_ping() {
  ping -c 1 $1 > /dev/null
  [ $? -eq 0 ] && snmp_get $i
}


snmp_get(){
fecha=`date +'%Y-%m-%d'`
snmpget -t 2 -r 1  -v1 -c nicos2012 $i iso.3.6.1.2.1.1.5.0 iso.2.840.10036.1.1.1.1.5 iso.2.840.10036.1.1.1.9.5 | cut -d '"' -f 2 >> /var/log/BS_Antenas/$fecha.log
echo "$i" >> /var/log/BS_Antenas/$fecha.log
echo "_____________________________________" >> /var/log/BS_Antenas/$fecha.log
echo " " >> /var/log/BS_Antenas/$fecha.log
echo " " >> /var/log/BS_Antenas/$fecha.log
}

for i in 172.16.{1..8}.{20..252}; do
    is_alive_ping $i & disown
done