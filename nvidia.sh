vim /etc/apt/sources.list

tar -zxvf install_flash_player_11_linux.x86_64.tar.gz
cp libflashplayer.so /usr/lib/mozilla/plugins/
sed 's/quiet/quiet nouveau.modeset=0/g' -i /etc/default/grub
update-grub
reboot

apt-get update
apt-get upgrade
apt-get dist-upgrade
apt-get install -y linux-headers-$(uname -r)
dpkg --add-architecture i386
apt-get update
apt-get upgrade
apt-get install ia32-libs
apt-get install make
apt-get install gcc
service gdm3 stop
chmod 755 NVIDIA-Linux-x86_64-319.17.run
./NVIDIA-Linux-x86_64-319.17.run
reboot
vim /usr/share/nvidia/nvidia-application-profiles-319.17-rc
vim /usr/share/doc/NVIDIA_GLX-1.0/README.txt

