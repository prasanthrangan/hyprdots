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
    elif [ "$X_MODE" == "light" ] ; then
        S_MODE="dark"
    else
        echo "ERROR: unable to fetch wallpaper mode."
    fi
else
    echo "ERROR: unknown mode, use 'dark', 'light' or 'switch'."
    exit 1
fi

### swwwallpaper ###
x=`echo $S_MODE | cut -c 1`
$CFGDIR/swww/swwwallpaper.sh -$x
sleep 1

### waybar ###
ln -fs $CFGDIR/waybar/${S_MODE}.css $CFGDIR/waybar/style.css
killall -SIGUSR2 waybar

