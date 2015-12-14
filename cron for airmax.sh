#!/bin/bash
#http://community.ubnt.com/t5/airOS-Software-Configuration/crond-for-airos-5/td-p/350458
cd /etc/persistent
tar xvf crond.tar 
./rc.prestart
save
/usr/etc/init.d/plugin start crond

crontab -e
ps | grep "cron"