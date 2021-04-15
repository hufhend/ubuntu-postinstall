#   **************************************
#   small automation of VPN preparation
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
mv *.crt client.crt
mv *.key client.key
cp /home/vaclav/install/NTB/VPN/*.ovpn /home/vaclav/install/NTB/VPN/ca.crt .
openssl rand -base64 18 > login
chmod 400 *.key *.crt 
chmod 600 login
