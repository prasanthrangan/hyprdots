#!/usr/bin/env sh

# wallpaper var
EnableWallDcol=0
cacheDir="$HOME/.config/swww/.cache"

# theme var
gtkTheme=`gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g"`
gtkMode=`gsettings get org.gnome.desktop.interface color-scheme | sed "s/'//g" | awk -F '-' '{print $2}'`

# notification var
ncolor="-h string:bgcolor:#191724 -h string:fgcolor:#faf4ed -h string:frcolor:#56526e"

if [ "${gtkMode}" == "light" ] ; then
    ncolor="-h string:bgcolor:#f4ede8 -h string:fgcolor:#9893a5 -h string:frcolor:#908caa"
fi

