#!/usr/bin/env sh

## main script ##
CFGDIR="$HOME/.config"
X_MODE=$1

## check mode ##
if [ "$X_MODE" == "dark" ] || [ "$X_MODE" == "light" ] ; then
    S_MODE="$X_MODE"

elif [ "$X_MODE" == "switch" ] ; then
    X_MODE=`readlink $CFGDIR/swww/wall.set | awk -F "." '{print $NF}'`

    if [ "$X_MODE" == "dark" ] ; then
        S_MODE="light"
        kvantummanager --set Catppuccin-Latte-Rosewater
        gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Latte'

    elif [ "$X_MODE" == "light" ] ; then
        S_MODE="dark"
        kvantummanager --set Catppuccin-Mocha-Rosewater
        gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Mocha-B'

    else
        echo "ERROR: unable to fetch wallpaper mode."
    fi

else
    echo "ERROR: unknown mode, use 'dark', 'light' or 'switch'."
    exit 1
fi

### hyprland ###
ln -fs $CFGDIR/hypr/${S_MODE}.conf $CFGDIR/hypr/hyprland.conf
hyprctl reload

### swwwallpaper ###
x=`echo $S_MODE | cut -c 1`
$CFGDIR/swww/swwwallpaper.sh -$x

### kitty ###
ln -fs $CFGDIR/kitty/${S_MODE}.conf $CFGDIR/kitty/theme.conf
killall -SIGUSR1 kitty

### waybar ###
ln -fs $CFGDIR/waybar/${S_MODE}.css $CFGDIR/waybar/style.css
sleep 1
killall -SIGUSR2 waybar

