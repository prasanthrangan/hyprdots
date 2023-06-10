#!/usr/bin/env sh

## set variables ##
BaseDir=`dirname $(realpath $0)`
ConfDir="$HOME/.config"
ThemeCtl="$ConfDir/swww/wall.ctl"

## evaluate options ##
while getopts "npst" option ; do
    case $option in

    n ) # set next theme
        ThemeSet=`head -1 $ThemeCtl | cut -d '|' -f 2` #default value
        flg=0
        while read line
        do
            if [ $flg -eq 1 ] ; then
                ThemeSet=`echo $line | cut -d '|' -f 2`
                break
            elif [ `echo $line | cut -d '|' -f 1` -eq 1 ] ; then
                flg=1
            fi
        done < $ThemeCtl
        ;;

    p ) # set previous theme
        ThemeSet=`tail -1 $ThemeCtl | cut -d '|' -f 2` #default value
        flg=0
        while read line
        do
            if [ $flg -eq 1 ] ; then
                ThemeSet=`echo $line | cut -d '|' -f 2`
                break
            elif [ `echo $line | cut -d '|' -f 1` -eq 1 ] ; then
                flg=1
            fi
        done < <( tac $ThemeCtl )
        export xtrans="outer"
        ;;

    s ) # set selected theme
        shift $((OPTIND -1))
        ThemeSet=$1
        ;;

    t ) # display tooltip
        echo ""
        echo "󰆊 Next/Previous Theme"
        exit 0 ;;

    * ) # invalid option
        echo "n : set next theme"
        echo "p : set previous theme"
        echo "s : set theme from parameter"
        echo "t : display tooltip"
        exit 1 ;;
    esac
done

## update theme control ##
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


### swwwallpaper ###
getWall=`grep '^1|' $ThemeCtl | cut -d '|' -f 3`
getWall=`eval echo $getWall`
ln -fs $getWall $ConfDir/swww/wall.set
$ConfDir/swww/swwwallpaper.sh

if [ $? -ne 0 ] ; then
    echo "ERROR: Unable to set wallpaper"
    exit 1
fi


### kitty ###
ln -fs $ConfDir/kitty/themes/${ThemeSet}.conf $ConfDir/kitty/themes/theme.conf
killall -SIGUSR1 kitty


### qt5ct ###
sed -i "/^color_scheme_path=/c\color_scheme_path=$ConfDir/qt5ct/colors/${ThemeSet}.conf" $ConfDir/qt5ct/qt5ct.conf
IconSet=`awk -F "'" '$0 ~ /gsettings set org.gnome.desktop.interface icon-theme/{print $2}' $ConfDir/hypr/themes/${ThemeSet}.conf`
sed -i "/^icon_theme=/c\icon_theme=${IconSet}" $ConfDir/qt5ct/qt5ct.conf


### flatpak GTK ###
flatpak --user override --env=GTK_THEME="${ThemeSet}"
flatpak --user override --env=ICON_THEME="${IconSet}"


### rofi ###
ln -fs $ConfDir/rofi/themes/${ThemeSet}.rasi $ConfDir/rofi/themes/theme.rasi


### hyprland ###
ln -fs $ConfDir/hypr/themes/${ThemeSet}.conf $ConfDir/hypr/themes/theme.conf
hyprctl reload


### waybar ###
ln -fs $ConfDir/waybar/themes/${ThemeSet}.css $ConfDir/waybar/style.css
sleep 1
killall -SIGUSR2 waybar

