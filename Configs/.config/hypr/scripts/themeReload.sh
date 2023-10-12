#!/usr/bin/env sh

# set variables
ScrDir=`dirname $(realpath $0)`
source ${ScrDir}/globalcontrol.sh

#just for calling the Globalsh
#export reload_flag=1
 




currentTheme=$(awk -F '|' '$1 ~ /1/ {print $2}' ~/.config/swww/wall.ctl)
#echo "currnt $currentTheme "
ThemeSet="$currentTheme"
#echo "theme $ThemeSet"



# update theme control
if [ `cat $ThemeCtl | awk -F '|' -v thm=$ThemeSet '{if($2==thm) print$2}' | wc -w` -ne 1 ] ; then
    echo "Unknown theme selected: $ThemeSet"
    echo "Available themes are:"
    cat $ThemeCtl | cut -d '|' -f 2
    exit 1
else
    echo "Selected theme: $ThemeSet"
    sed -i "s/^1/0/g" $ThemeCtl
    awk -F '|' -v thm=$ThemeSet '{OFS=FS} {if($2==thm) $1=1; print$0}' $ThemeCtl > ${ScrDir}/tmp && mv ${ScrDir}/tmp $ThemeCtl
fi



# swwwallpaper
getWall=`grep '^1|' $ThemeCtl | cut -d '|' -f 3`
getWall=`eval echo $getWall`
getName=`basename $getWall`
ln -fs $getWall $ConfDir/swww/wall.set
ln -fs $cacheDir/${ThemeSet}/${getName}.rofi $ConfDir/swww/wall.rofi
ln -fs $cacheDir/${ThemeSet}/${getName}.blur $ConfDir/swww/wall.blur
${ScrDir}/swwwallpaper.sh

if [ $? -ne 0 ] ; then
    echo "ERROR: Unable to set wallpaper"
    exit 1
fi
case $1 in 

all )
# code
sed -i "/workbench.colorTheme/c\    \"workbench.colorTheme\": \"${ThemeSet}\"," $ConfDir/Code/User/settings.json


# kitty
ln -fs $ConfDir/kitty/themes/${ThemeSet}.conf $ConfDir/kitty/themes/theme.conf
killall -SIGUSR1 kitty


# qt5ct
sed -i "/^color_scheme_path=/c\color_scheme_path=$ConfDir/qt5ct/colors/${ThemeSet}.conf" $ConfDir/qt5ct/qt5ct.conf
IconSet=`awk -F "'" '$0 ~ /gsettings set org.gnome.desktop.interface icon-theme/{print $2}' $ConfDir/hypr/themes/${ThemeSet}.conf`
sed -i "/^icon_theme=/c\icon_theme=${IconSet}" $ConfDir/qt5ct/qt5ct.conf


# gtk3
sed -i "/^gtk-theme-name=/c\gtk-theme-name=${ThemeSet}" $ConfDir/gtk-3.0/settings.ini
sed -i "/^gtk-icon-theme-name=/c\gtk-icon-theme-name=${IconSet}" $ConfDir/gtk-3.0/settings.ini


# flatpak GTK
flatpak --user override --env=GTK_THEME="${ThemeSet}"
flatpak --user override --env=ICON_THEME="${IconSet}"


# hyprland
ln -fs $ConfDir/hypr/themes/${ThemeSet}.conf $ConfDir/hypr/themes/theme.conf
hyprctl reload


# send notification
source ${ScrDir}/globalcontrol.sh
dunstify $ncolor "theme" -a " ${ThemeSet}" -i "~/.config/dunst/icons/hyprdots.png" -r 91190 -t 2200


# rofi & waybar
${ScrDir}/swwwallbash.sh $getWall



;;
waybar)

$BaseDir/swwwallbash.sh $getWall

;;

esac
    