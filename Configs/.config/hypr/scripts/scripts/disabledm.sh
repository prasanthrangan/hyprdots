#!/bin/bash
clear

cat <<"EOF"
 ____  _           _     _      ____  __  __ 
|  _ \(_)___  __ _| |__ | | ___|  _ \|  \/  |
| | | | / __|/ _` | '_ \| |/ _ \ | | | |\/| |
| |_| | \__ \ (_| | |_) | |  __/ |_| | |  | |
|____/|_|___/\__,_|_.__/|_|\___|____/|_|  |_|
                                             
EOF

echo "Hyprland recommends the start with the tty login."
echo "You can deactivate the current display manager (if exists)."
echo ""
echo "-> Do you really want to deactivate the display manager?"
while true; do
    read -p "Do you want to enable the sddm display manager and setup theme? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            if [ -f /etc/systemd/system/display-manager.service ]; then
                sudo rm /etc/systemd/system/display-manager.service
                echo "Current display manager removed."
            else
                echo "No active display manager found."
            fi
        break;;
        [Nn]* ) 
            exit
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done