#!/bin/bash
_getHeader "$name" "$author"

if [ -f /etc/systemd/system/display-manager.service ]; then
    if gum confirm "Do you want to disable the current display manager?" ;then
        sudo rm /etc/systemd/system/display-manager.service
        echo "Current display manager removed. Please reboot your system."
        sleep 2
    fi
else
    if gum confirm "Do you want to enable SDDM as your display manager?" ;then
        sudo systemctl enable sddm.service
        echo "Display manager SDDM has been enabled. Please reboot your system."
        sleep 2
    fi
fi

_goBack
