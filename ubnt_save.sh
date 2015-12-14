#!/bin/bash
echo "Introduce la IP de la antena"
read HOST
USER="ubnt"
PASS="ubnt"
echo "$USER@$HOST $PASS"

echo y | plink -ssh $HOST -l $USER -pw $PASS "sleep 2 && cfgmtd -w -p /etc/"
