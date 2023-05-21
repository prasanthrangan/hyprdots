#!/usr/bin/env sh

## get current theme ##
BaseDir=`dirname $(realpath $0)`
ConfDir="$HOME/.config"
ThemeCtl="$ConfDir/swww/wall.ctl"
ThemeSet=$1

if [ `grep '^1|' $ThemeCtl | wc -l` -ne 1 ] ; then
    echo "ERROR : $ThemeCtl Unable to fetch theme..."
else
    CurTheme=`grep '^1|' $ThemeCtl | cut -d '|' -f 2`
    echo "Current theme: $CurTheme"
fi

if [ `cat $ThemeCtl | awk -F '|' -v thm=$ThemeSet '{if($2==thm) print$2}' | wc -w` -ne 1 ] ; then
    echo "Unknown theme selected: $ThemeSet"
    echo "Available themes are:"
    cat $ThemeCtl | cut -d '|' -f 2
    exit 1
else
    echo "Selected theme: $ThemeSet"
    sed -i "s/^1/0/g" $ThemeCtl
    awk -F '|' -v thm=$ThemeSet '{OFS=FS} {if($2==thm) $1=1; print$0}' $ThemeCtl > $BaseDir/tmp && mv $BaseDir/tmp $ThemeCtl
fi


### hyprland ###
ln -fs $ConfDir/hypr/themes/${ThemeSet}.conf $ConfDir/hypr/themes/theme.conf
hyprctl reload


### swwwallpaper ###
getWall=`grep '^1|' $ThemeCtl | cut -d '|' -f 3`
getWall=`eval echo $getWall`
ln -fs $getWall $ConfDir/swww/wall.set
$ConfDir/swww/swwwallpaper.sh


### kitty ###
ln -fs $ConfDir/kitty/themes/${ThemeSet}.conf $ConfDir/kitty/themes/theme.conf
killall -SIGUSR1 kitty

