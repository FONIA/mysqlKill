#!bin/bash;
path="/etc/sysctl.conf"
sudo echo -e "#[`date -d today +"%Y-%m-%d %T"`]-[`whoami`]-[缓解tcp大量time_wait连接]" >> $path
sudo echo "net.ipv4.tcp_syncookies=1" >> $path
sudo echo "net.ipv4.tcp_tw_reuse=1" >> $path
sudo echo "net.ipv4.tcp_tw_recycle=1" >> $path