#!/bin/bash
#grep collectd = nombre del proceso a matar
#grep -v kill_collectd.sh = nombre del script que quiero evitar que salga su pid
process=`ps -fe | grep collectd | grep -v grep | grep -v kill_collectd.sh | awk '{print $2}'`
#echo $process
kill -9 $process