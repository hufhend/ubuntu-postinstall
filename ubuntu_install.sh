#   *********************************************
#   script for NTB install - Ubuntu 22.04, part 1
#   begin     : Fri 25 Sep 2020
#   copyright : (c) 2022 Václav Dvorský
#   email     : vaclav.dvorsky@hotmail.com
#   $Id: ubuntu_install.sh, v3.10 14/09/2022
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
    # complete updates
    sudo apt -f install && sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y
    sudo ufw enable
    sudo ufw allow from 192.168.0.0/21 to any port ssh comment 'Open ssh port 22'
    # docker installation
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    apt-cache policy docker-ce
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo systemctl status docker
    sudo usermod -aG docker ${USER}
    echo Switch to another user, continue with script ubuntu_install_2.sh
    su - ${USER}
  exit
fi
    #here go superuser commands
    echo This script cannot run root
