#!/bin/zsh

#############################################################
#This Script auto starts my Hyprland faster exporting envs
#############################################################

#[ ! -f /run/udev/data/+drm:card0-eDP-1 ] \
 #&& sudo systemctl restart systemd-udev-trigger > /dev/null
#sudo systemctl status iwd|grep Active..active \
 #|| sudo systemctl start iwd &
#echo "Starting script..."
#echo "Checking for DRM file..."
#while [ ! -f /run/udev/data/+drm:card1-eDP-1 ] ; do echo "waiting for drm" && sleep 0.2 ; done
#echo "DRM file check completed."
#echo "Setting environment variables..."

#exec /usr/bin/prime-offload

export USER=khing
[ -z $TERM ] && export TERM=linux
[ -z $LOGNAME ] && export LOGNAME=$USER
[ -z $HOME ] && export HOME=/home/$USER
[ -z $LANG ] && export LANG=C.UTF-8
[ -z $PATH ] && export PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl
[ -z $XDG_SEAT ] && export XDG_SEAT=seat0
[ -z $XDG_SESSION_TYPE ]  && export XDG_SESSION_TYPE=tty
[ -z $XDG_SESSION_CLASS ] && export XDG_SESSION_CLASS=user
[ -z $XDG_VTNR ] && export XDG_VTNR=1
[ -z $USER ] || export USER=$( id -n -u )
[ -n $UID ] || export UID=$( id -u )
[ -z $XDG_RUNTIME_DIR ] && export XDG_RUNTIME_DIR=/run/user/UID
[ -z $DBUS_SESSION_BUS_ADDRESS ] && export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/UID/bus


export WLR_DRM_DEVICES=/dev/dri/card2 # card 2 and intel kay nouveau ako gamit 0 sya if nvidia
export HYPRLAND_LOG_WLR=1
export XCURSOR_SIZE=20
export XCURSOR_THEME=Bibata-Modern-Classic
export GTK_THEME=Adwaita-dark

#echo "Environment variables set."
#echo "Checking for DRM file again..."
#[ ! -f /run/udev/data/+drm:card1-eDP-1 ]
#exec /usr/bin/prime-offload
#sleep 0.2
sleep 1 
exec Hyprland > .hyprland.log.txt 2> .hyprland.err.txt
#exec Hyprland > /dev/null
#exec Hyprland > .hyprland.log.txt 2> .hyprland.err.txt
#exec Hyprland --config /home/khingland/.config/hypr/hyprland.conf
#exec Hyprland -c > .hyprland.log.txt 2> .hyprland.err.txt #Hyprdots Them
