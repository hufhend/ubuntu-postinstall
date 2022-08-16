#   *********************************************
#   script for NTB install - Ubuntu 20.04, part 1
#   begin     : Fri 25 Sep 2020.
#   copyright : (c) 2021 Václav Dvorský
#   email     : vaclav.dvorsky@hotmail.com
#   $Id: ubuntu_install.sh, v3.02 20/01/2021
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
    # kompletní aktualizace
    sudo apt-get -f install && sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y && sudo apt-get autoremove -y
    sudo ufw enable
    # instalace dockeru
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
