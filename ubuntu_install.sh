#   *********************************************
#   script for NTB install - Ubuntu 18.04, part 2
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
    # kompletní aktualizace
    sudo apt-get install && sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y && sudo apt-get autoremove -y
    # instalace dockeru
    sudo ufw enable
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"
    sudo apt-get update
    apt-cache policy docker-ce
    sudo apt install -y docker-ce
    sudo systemctl status docker
    sudo usermod -aG docker ${USER}
    echo Switch to another user, continue with script ubuntu_install_2.sh
    su - ${USER}
  exit
fi
    #here go superuser commands
    echo This script cannot run root
