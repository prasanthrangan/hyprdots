#!/bin/bash

sddmback="/usr/share/sddm/themes/Corners/backgrounds/bg.png"
sddmconf="/usr/share/sddm/themes/Corners/theme.conf"
slnkwall="${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.set"

if [ "$(getfacl -p /home/${USER} | grep user:sddm | awk '{print substr($0,length)}')" != "x" ] ; then
    echo "granting sddm execution access to /home/${USER}..."
    setfacl -m u:sddm:x /home/${USER}
fi

echo "Copying dynamic wallpaper to SDDM background location..."
cp "${slnkwall}" "${sddmback}"

echo "setting static sddm background..."
sed -i "/^Background=/c\Background=\"${sddmback}\"" "${sddmconf}"
