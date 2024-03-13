#!/usr/bin/env sh

# wallpaper var
EnableWallDcol=0
ConfDir="${XDG_CONFIG_HOME:-$HOME/.config}"
CloneDir="$HOME/Hyprdots"
cacheDir="$HOME/.cache/hyprdots"
ThemeCtl="${ConfDir}/hyprdots/theme.ctl"
WallbashDir="${ConfDir}/hyprdots/wallbash"

# theme var
gtkTheme=`gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g"`
gtkIcon=`gsettings get org.gnome.desktop.interface icon-theme | sed "s/'//g"`
gtkMode=`gsettings get org.gnome.desktop.interface color-scheme | sed "s/'//g" | awk -F '-' '{print $2}'`

# hypr var
hypr_border=`hyprctl -j getoption decoration:rounding | jq '.int'`
hypr_width=`hyprctl -j getoption general:border_size | jq '.int'`

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
