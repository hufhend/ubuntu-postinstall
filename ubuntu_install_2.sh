#   *********************************************
#   script for NTB install - Ubuntu 22.04, part 2
#   begin     : Fri 25 Sep 2020
#   copyright : (c) 2022 Václav Dvorský
#   email     : vaclav.dvorsky@hotmail.com
#   $Id: ubuntu_install.sh, v3.26 29/11/2022
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
    # sudo curl -L "https://github.com/docker/compose/releases/download/v2.11.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    # sudo chmod +x /usr/local/bin/docker-compose
    # mkdir -p $HOME/.docker/cli-plugins/
    # ln -s /usr/local/bin/docker-compose $HOME/.docker/cli-plugins/docker-compose
    docker compose version
    sudo apt install git
    sudo apt install -y openvpn
    sudo apt install -y network-manager-openvpn
    sudo apt install -y network-manager-openvpn-gnome openvpn-systemd-resolved
    sudo apt -f install && sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y
    # set up networks
    # sudo rsync -a ca.crt client.crt client.key login *.ovpn /etc/openvpn/client
    # sudo chmod 400 /etc/openvpn/client/*
    # sudo nmcli connection import type openvpn file /etc/openvpn/client/vpn.ovpn
    sudo nano /etc/hostname
    # other and unimportant things
    sudo apt install -y htop
    sudo apt install -y screen mc solaar
    sudo apt install -y sysstat
    sudo systemctl enable sysstat
    sudo sed -i 's/false/true/g' /etc/default/sysstat
    sudo apt install -y smartmontools
    sudo systemctl enable smartmontools
    sudo apt install -y fail2ban
    # install VirtualBox
    sudo apt install -y virtualbox virtualbox-guest-additions-iso virtualbox-ext-pack
    # install Czech fonts
    wget https://github.com/hufhend/ubuntu-postinstall/raw/main/fonts.tar.gz
    sudo tar xvfz fonts.tar.gz -C /usr/local/share

    # install Firefox
    sudo snap remove firefox
    sudo add-apt-repository ppa:mozillateam/ppa
    echo '
    Package: *
    Pin: release o=LP-PPA-mozillateam
    Pin-Priority: 1001
    ' | sudo tee /etc/apt/preferences.d/mozilla-firefox
    echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox
    sudo apt install firefox

    # install Chrome
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    rm google-chrome-stable_current_amd64.deb
    # install OnlyOffice
    wget https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb
    sudo apt install ./onlyoffice-desktopeditors_amd64.deb
    sudo apt --fix-broken install
    rm onlyoffice-desktopeditors_amd64.deb

  exit
fi
    #here go superuser commands
    echo This script cannot run root
