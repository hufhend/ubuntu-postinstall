#   ***********************************************
#   script for server install - Ubuntu 22.04
#   begin     : Wed 5 Apr 2023
#   copyright : (c) 2023 Václav Dvorský
#   email     : vaclav.dvorsky@hotmail.com
#   $Id: install_ubuntu_server.sh, v1.04 18/05/2023
#   ***********************************************
#
#   --------------------------------------------------------------------
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public Licence as published by
#   the Free Software Foundation; either version 2 of the Licence, or
#   (at your option) any later version.
#   --------------------------------------------------------------------

#!/bin/bash
if ! [ $(id -u) = 0 ]; then
    net=192.168.0.0/21
    user=${USER}
    # complete updates
    sudo apt -f install && sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y
    sudo apt install -y ssh 
    sudo nano /etc/hostname
    # install useful SW
    sudo apt install -y htop screen mc sysstat smartmontools lm-sensors fail2ban open-iscsi nfs-common
    # sudo apt install keepalived
    sudo sed -i 's/false/true/g' /etc/default/sysstat
    sudo systemctl enable sysstat smartmontools
    sudo systemctl start sysstat
    # install monitoring service
    sudo apt-get install -y prometheus-node-exporter
    # enable firewall rules 
    sudo ufw allow from $net to any port ssh comment 'Allow ssh port 22'
    sudo ufw allow http  comment 'Allow http from anywhere'
    sudo ufw allow https comment 'Allow https from anywhere'
    sudo ufw allow from $net to any port 53 comment 'Allow DNS'
    sudo ufw allow from $net to any port 6443 proto tcp comment 'Allow Kubernetes API server'
    sudo ufw allow from $net to any port 2379 proto tcp comment 'Allow etcd-client'
    sudo ufw allow from $net to any port 2380 proto tcp comment 'Allow etcd-server'
    sudo ufw allow from $net to any port 10250 proto tcp comment 'Allow Kubelet API'
    sudo ufw allow from $net to any port 10259 proto tcp comment 'Allow kube-scheduler'
    sudo ufw allow from $net to any port 10257 proto tcp comment 'Allow kube-controller manager'
    sudo ufw allow from $net to any port 30000:32767 proto tcp comment 'Allow NodePort Services'
    sudo ufw allow from $net to any port 9100 proto tcp comment 'Allow node-exporter'
    sudo ufw allow from $net to any port 9153 proto tcp comment 'Allow CoreDNS metrics'
    sudo ufw allow from $net to any port 9253 proto tcp comment 'Allow NodeLocal DNS metrics'
    sudo ufw enable
    # add user to sudoers
    sudo sh -c "echo '$user ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/$user"
    # block sleeping - especially for NTB
    sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=ignore/g' /etc/systemd/logind.conf
    sudo sed -i 's/#IdleAction=ignore/IdleAction=ignore/g' /etc/systemd/logind.conf
    sudo sed -i 's/IgnoreLid=false/IgnoreLid=true/g' /etc/UPower/UPower.conf
    sudo ufw disable
  exit
fi
    #here go superuser commands
    echo This script cannot run root
