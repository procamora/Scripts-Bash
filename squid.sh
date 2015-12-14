#!/bin/bash
ip_eth0="192.168.1.5"
mask_eth0="255.255.255.0"
gate_eth0="192.168.1.1"
ip_eth1="192.168.0.5"
mask_eth1="255.255.255.0"

sed -i "s/iface eth0 inet dhcp/iface eth0 inet static/g" /etc/network/interfaces
echo "address $ip_eth0" >> /etc/network/interfaces
echo "netmask $mask_eth0" >> /etc/network/interfaces
echo "gateway $gate_eth0" >> /etc/network/interfaces
echo "## Interfaz eth1"
echo "auto eth1"  >> /etc/network/interfaces
echo "iface eth1 inet static"  >> /etc/network/interfaces
echo "address $ip_eth1" >> /etc/network/interfaces
echo "netmask $mask_eth1" >> /etc/network/interfaces

echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" > /etc/resolv.conf

/etc/init.d/networking restart
ifup eth0
ifup eth1

apt-get install squid

cp /etc/squid/squid.conf /etc/squid/squic.con_backup

sed -i "s/http_port 3128/http_port 3128 transparent/g" /etc/squid/squid.conf
sed -i "s/cache_mem 8 MB/cache_mem 30 MB/g" /etc/squid/squid.conf
sed -i "s/cache_dir ufs /var/spool/squid 100 16 256/cache_dir ufs /var/spool/squid 2000 16 256/g" /etc/squid/squid.conf

linea_acl=`sed -n 608p /etc/squid/squid.conf`
linea_access=`sed -n 676p /etc/squid/squid.conf`
ip_red="192.168.0.0\/24"
sed -i "s/$linea_acl/acl red_local src $ip_red/g" /etc/squid/squid.conf
sed -i "s/$linea_access/http_access allow red_local/g" /etc/squid/squid.conf

sed -i "s/maximum_object_size_in_memory 8 KB/maximum_object_size_in_memory 100 KB/g" /etc/squid/squid.conf
sed -i "s/# cache_replacement_policy/cache_replacement_policy heap/g" /etc/squid/squid.conf

/etc/init.d/squid restart

iptables -t nat -A POSTROUTING -o eth0 -j SNAT  --to $ip_eth0
iptables  -t nat -A PREROUTING -i eth1 -p tcp --dport 80 -j REDIRECT --to-port 3128
#permitir conexión entre las interfaces de red
echo 1 > /proc/sys/net/ipv4/ip_forward

#creamos el fichero para que se inicie al inicio del sistema
echo "iptables -t nat -A POSTROUTING -o eth0 -j SNAT  --to $ip_eth0" > /tmp/proxy_rules.sh
echo "iptables  -t nat -A PREROUTING -i eth1 -p tcp --dport 80 -j REDIRECT --to-port  3128" >> /tmp/proxy_rules.sh
echo "echo 1 > /proc/sys/net/ipv4/ip_forward" >> /tmp/proxy_rules.sh
chmod +x /tmp/proxy_rules.sh
cp /tmp/proxy_rules.sh /etc/init.d/

squid -k reconfigure