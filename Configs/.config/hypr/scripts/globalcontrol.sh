#!/usr/bin/env sh

# wallpaper var
EnableWallDcol=0
ConfDir="$HOME/.config"
ThemeCtl="$ConfDir/swww/wall.ctl"
cacheDir="$ConfDir/swww/.cache"

# theme var
gtkTheme=`gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g"`
gtkMode=`gsettings get org.gnome.desktop.interface color-scheme | sed "s/'//g" | awk -F '-' '{print $2}'`

# hypr var
hypr_border=`hyprctl -j getoption decoration:rounding | jq '.int'`
hypr_width=`hyprctl -j getoption general:border_size | jq '.int'`

# notification var
#ncolor="-h string:bgcolor:#191724 -h string:fgcolor:#faf4ed -h string:frcolor:#56526e"
#
#if [ "${gtkMode}" == "light" ] ; then
#    ncolor="-h string:bgcolor:#f4ede8 -h string:fgcolor:#9893a5 -h string:frcolor:#908caa"
#fi

# pacman fns
pkg_installed()
{
    local PkgIn=$1

    if pacman -Qi $PkgIn &> /dev/null
    then
        #echo "${PkgIn} is already installed..."
        return 0
    else
        #echo "${PkgIn} is not installed..."
        return 1
    fi
}

get_aurhlpr()
{
    if pkg_installed yay
    then
        aurhlpr="yay"
    elif pkg_installed paru
    then
        aurhlpr="paru"
    fi
}

