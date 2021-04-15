#   **************************************
#   post installation script to copy VPN
#   begin     : Tue 12 Jan 2021
#   copyright : (c) 2021 Václav Dvorský
#   email     : vaclav.dvorsky@hotmail.com
#   $Id: copy_vpn.sh, v1.02 15/04/2021
#   **************************************
#
#   --------------------------------------------------------------------
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public Licence as published by
#   the Free Software Foundation; either version 2 of the Licence, or
#   (at your option) any later version.
#   --------------------------------------------------------------------

#!/bin/bash
if ! [ $(id -u) = 0 ]; then
    sudo rsync -a ca.crt client.crt client.key login *.ovpn /etc/openvpn/client
    sudo chmod 400 /etc/openvpn/client/*
  exit
fi
    #here go superuser commands
    echo This script cannot run root
