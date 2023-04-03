#!/bin/bash
#|---/ /+-------------------------------------------+---/ /|#
#|--/ /-| Script to enable/diable systemctl service |--/ /-|#
#|-/ /--| Prasanth Rangan                           |-/ /--|#
#|/ /---+-------------------------------------------+/ /---|#

source global_fn.sh

if (( $EUID != 0 ))
then
    echo "you dont have permission to enable services, please run as sudo..."
    exit 1
fi

service_input="${1:-bluetooth}"

if service_check $service_input
then
    echo "$service_input service is already enabled, enjoy..."
else
    echo "$service_input service is not running, enabling..."
    systemctl start ${service_input}.service
    systemctl enable ${service_input}.service
    sed -i "/^#AutoEnable=/c\AutoEnable=true" /etc/bluetooth/main.conf
    echo "$service_input service enabled, auto enable updated..."
fi

exit 0
