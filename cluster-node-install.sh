#   **********************************************
#   script for server install - Ubuntu 22.04
#   begin     : Wed 5 Apr 2023
#   copyright : (c) 2023 Václav Dvorský
#   email     : vaclav.dvorsky@hotmail.com
#   $Id: cluster-node-install.sh, v1.09 17/11/2023
#   **********************************************
#
#   --------------------------------------------------------------------
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public Licence as published by
#   the Free Software Foundation; either version 2 of the Licence, or
#   (at your option) any later version.
#   --------------------------------------------------------------------
#
#   This post-install script prepares the Ubuntu NTB (desktop) for the kubernetes node role.
#   It will install necessary and useful software, stop sleeping and disable unnecessary services
#   including Gnome.
#   Using NTB makes sense in terms of price and power consumption. Gnome may be useful if repairs
#   are needed. The NTB also has a display, keyboard, mouse and its own UPS.

#!/bin/bash
if ! [ $(id -u) = 0 ]; then
    net=192.168.0.0/21
    user=${USER}
    # complete updates
    sudo apt -f install && sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y
    sudo apt install -y ssh
    sudo nano /etc/hostname

    # install useful SW
    sudo apt install -y htop screen mc sysstat smartmontools lm-sensors fail2ban open-iscsi nfs-common ethtool
    sudo sed -i 's/false/true/g' /etc/default/sysstat
    sudo systemctl enable sysstat smartmontools
    sudo systemctl start sysstat
    # install monitoring service
    sudo apt install -y prometheus-node-exporter

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

    # block the start of GNOME Virtual File System
    sudo systemctl mask gvfs-afc-volume-monitor
    sudo systemctl mask gvfs-daemon
    sudo systemctl mask gvfs-goa-volume-monitor
    sudo systemctl mask gvfs-gphoto2-volume-monitor
    sudo systemctl mask gvfs-metadata
    sudo systemctl mask gvfs-mtp-volume-monitor
    sudo systemctl mask gvfs-udisks2-volume-monitor
    sudo systemctl disable snapd

    # block GUI start - black screen only
    sudo systemctl disable gdm

    # disable firewall rules
    sudo ufw disable

    # uncomment to install keepalived
    # sudo apt install -y keepalived
    # # keepalived configuration
    # content='vrrp_instance VI_1 {

    #     state MASTER            # or BACKUP
    #     interface enp8s0        # change the network card by "ip a"
    #     virtual_router_id 51
    #     priority 255            # reduce by one for each additional
    #     advert_int 1
    #     authentication {
    #         auth_type PASS
    #         auth_pass 12345
    #     }
    #     virtual_ipaddress {
    #         192.168.3.110/24
    #     }
    # }'
    # file_path="/etc/keepalived/keepalived.conf"
    # echo "$content" > "pom.txt"
    # sudo cp pom.txt "$file_path" && rm pom.txt

    # Wake-On-Lan Activation
    content='[Unit]
Description=Enable Wake-up on LAN

[Service]
Type=oneshot
# Change to your card by "ip a"
ExecStart=/sbin/ethtool -s enp8s0 wol g

[Install]
WantedBy=basic.target'
    file_path_wol="/etc/systemd/system/wol-enable.service"
    echo "$content" > "wol-enable.txt"
    sudo cp wol-enable.txt "$file_path_wol" && rm wol-enable.txt
    sudo systemctl enable wol-enable.service
    sudo systemctl start wol-enable.service

    # Add new Crontab
    current_cron=$(crontab -l 2>/dev/null)
    new_cron="# For more information see the manual pages of crontab(5) and cron(8)
# m h dom mon dow   command

# Check the first disk
00  1  *  *  0-5    sudo /usr/sbin/smartctl -t short /dev/sda 	2>/dev/null
00  2  *  *  sat    sudo /usr/sbin/smartctl -t long  /dev/sda 	2>/dev/null   # Saturday, duration 90 min

# Check the second disk
20  1  *  *  1-6    sudo /usr/sbin/smartctl -t short /dev/sdb 	2>/dev/null
00  2  *  *  sun    sudo /usr/sbin/smartctl -t long  /dev/sdb 	2>/dev/null   # Sunday,   duration  2 min

# Complete system update
17  3  *  *   *     sudo apt -f install && sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y

# Shut down the node and restart
30  6  1  *   *     kubectl drain --ignore-daemonsets --delete-emptydir-data $(uname -n) && sudo init 6"
    echo "$current_cron" > /tmp/mycron
    echo "$new_cron" >> /tmp/mycron
    crontab /tmp/mycron
    rm /tmp/mycron

  exit
fi
    #here go superuser commands
    echo This script cannot run root
