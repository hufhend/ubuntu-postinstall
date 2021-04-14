#   *********************************************
#   script for NTB install - Ubuntu 18.04, part 1
#   begin     : Fri 25 Sep 2020.
#   copyright : (c) 2021 Václav Dvorský
#   email     : vaclav.dvorsky@hotmail.com
#   $Id: ubuntu_install.sh, v2.02 18/10/2020
#   *********************************************
#
#   --------------------------------------------------------------------
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public Licence as published by
#   the Free Software Foundation; either version 2 of the Licence, or
#   (at your option) any later version.
#   --------------------------------------------------------------------

#!/bin/bash
if ! [ $(id -u) = 0 ]; then
    id -nG
    docker run hello-world
    docker ps -a
    systemctl is-enabled docker
    sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    docker-compose --version
    sudo apt-get install git
    sudo apt-get install -y openvpn 
    sudo apt-get install -y network-manager-openvpn
    sudo apt-get install -y network-manager-openvpn-gnome openvpn-systemd-resolved
    sudo apt-get install && sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y && sudo apt-get autoremove -y
    #nastavíme sítě
    #cd network
    sudo rsync -a ca.crt client.crt client.key login *.ovpn /etc/openvpn/client
    sudo chmod 400 /etc/openvpn/client/*
    #sudo nmcli connection import type openvpn file /etc/openvpn/client/vpn.ovpn
    sudo nano /etc/hostname
    #věci další a nedůležité
    sudo apt-get install -y sysstat
    sudo systemctl enable sysstat
    sudo sed -i 's/false/true/g' /etc/default/sysstat
    sudo apt-get install -y smartmontools
    sudo systemctl enable smartd
    sudo apt-get install -y fail2ban
    sudo tar xvfz fonts.tar.gz -C /usr/local/share
  exit
fi
    #here go superuser commands
    echo This script cannot run root
