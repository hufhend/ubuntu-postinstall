#   *********************************************
#   script for NTB install - Ubuntu 20.04, part 2
#   begin     : Fri 25 Sep 2020.
#   copyright : (c) 2022 Václav Dvorský
#   email     : vaclav.dvorsky@hotmail.com
#   $Id: ubuntu_install.sh, v3.20 03/01/2022
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
    # install Docker Compose v2
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.0.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    mkdir -p $HOME/.docker/cli-plugins/
    ln -s /usr/local/bin/docker-compose $HOME/.docker/cli-plugins/docker-compose
    docker compose version
    sudo apt-get install git
    sudo apt-get install -y openvpn 
    sudo apt-get install -y network-manager-openvpn
    sudo apt-get install -y network-manager-openvpn-gnome openvpn-systemd-resolved
    sudo apt-get -f install && sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y && sudo apt-get autoremove -y
    # set up networks
    sudo rsync -a ca.crt client.crt client.key login *.ovpn /etc/openvpn/client
    sudo chmod 400 /etc/openvpn/client/*
    # sudo nmcli connection import type openvpn file /etc/openvpn/client/vpn.ovpn
    sudo nano /etc/hostname
    # other and unimportant things
    sudo apt-get install -y sysstat
    sudo systemctl enable sysstat
    sudo sed -i 's/false/true/g' /etc/default/sysstat
    sudo apt-get install -y smartmontools
    sudo systemctl enable smartmontools
    sudo apt-get install -y fail2ban
    sudo apt-get install -y virtualbox virtualbox-guest-additions-iso virtualbox-ext-pack
    wget https://github.com/hufhend/ubuntu-postinstall/raw/main/fonts.tar.gz
    sudo tar xvfz fonts.tar.gz -C /usr/local/share
  exit
fi
    #here go superuser commands
    echo This script cannot run root
