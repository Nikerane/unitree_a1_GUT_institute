#!/bin/bash

# sudo ifconfig lo multicast
# sudo route add -net 224.0.0.0 netmask 240.0.0.0 dev lo
sudo ifconfig eth0 down
sudo ifconfig eth0 up 192.168.123.162 netmask 255.255.255.0

# sudo ifconfig lo down
# sudo ifconfig lo up 127.0.0.1  netmask 255.0.0.0

#sudo ifconfig enx000ec6612921 down
#sudo ifconfig enx000ec6612921 up 192.168.123.162 netmask 255.255.255.0

