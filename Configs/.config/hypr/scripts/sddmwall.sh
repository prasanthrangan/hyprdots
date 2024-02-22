#!/bin/bash

sddm_theme=$(grep -oP 'Current=\K.*' /etc/sddm.conf.d/kde_settings.conf)
sddmback="/usr/share/sddm/themes/${sddm_theme}/backgrounds/bg.png"
sddmconf="/usr/share/sddm/themes/${sddm_theme}/theme.conf"
slnkwall="${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.set"

if [ "$(getfacl -p /home/${USER} | grep user:sddm | awk '{print substr($0,length)}')" != "x" ] ; then
    echo "granting sddm execution access to /home/${USER}..."
    setfacl -m u:sddm:x /home/${USER}
fi

if [ "$(grep "Background=" "${sddmconf}")" == "Background=\"${slnkwall}\"" ] ; then
    echo "setting static sddm background..."
    sed -i "/^Background=/c\Background=\"${sddmback}\"" "${sddmconf}"
else
    echo "setting dynamic sddm background..."
    sed -i "/^Background=/c\Background=\"${slnkwall}\"" "${sddmconf}"
fi

