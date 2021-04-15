#   ******************************************
#   script for account renaming - Ubuntu 20.04
#   begin     : Mon 27 Apr 2020
#   copyright : (c) 2021 Václav Dvorský
#   email     : vaclav.dvorsky@hotmail.com
#   $Id: rename_user.sh, v1.02 15/04/2021
#   ******************************************
#
#   --------------------------------------------------------------------
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public Licence as published by
#   the Free Software Foundation; either version 2 of the Licence, or
#   (at your option) any later version.
#   --------------------------------------------------------------------

#!/bin/bash
if [ $(id -u) = 0 ]; then
    [ $# -lt 3 ] && exit 0
    usermod -l $1 -d /home/$1 -m betsys
    groupmod -n $1 betsys
    chfn -f "$2 $3" $1
  exit 0
fi
    echo "This script can run only root!"
    echo "Usage sh $0 newusername first_name surname"
    echo "Newusername is surname and first character from first name for example Jan Novák: sh $0 novakj Jan Novák"
