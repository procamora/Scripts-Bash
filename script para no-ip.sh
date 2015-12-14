#!/bin/sh
#./etc/rc.d/init.d/functions    #descomente/modifique para su killproc
case "$1" in
  start)
    echo "Iniciando noip2..."
    /usr/local/bin/noip2
  ;;
  stop)
    echo -n "Apagando noip2..."
    killproc -TERM /usr/local/bin/noip2
  ;;
  *)
    echo "Uso: $0 {start|stop}"
    exit 1
esac
exit 0

