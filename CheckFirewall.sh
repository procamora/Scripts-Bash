#!/bin/bash
while true; do
  firewall=`/etc/init.d/firewall status | wc -l`
  if [ $firewall -lt 30 ]; then
     `echo "Firewall apagado en el pbx1" | mail -s "Firewall apagado" procamora@github.com`
     `/etc/init.d/firewall start`
  fi
  sleep 1h
done
