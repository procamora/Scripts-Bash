#!/bin/bash
apt-get -y install network-manager-openvpn-gnome
apt-get -y install network-manager-pptp
apt-get -y install network-manager-pptp-gnome
apt-get -y install network-manager-strongswan
apt-get -y install network-manager-vpnc
apt-get -y install network-manager-vpnc-gnome
/etc/init.d/network-manager restart