#!/bin/bash
HOST="192.168.1.20"
USER="ubnt"
PASS="ubnt"

echo y | plink -ssh $HOST -l $USER -pw $PASS "echo 'echo \"<option value=\"511\">Compliance Test</option>\" >> /etc/ccodes.inc' > /etc/persistent/rc.poststart && chmod +x /etc/persistent/rc.poststart && cfgmtd -w -p /etc/ && reboot"
