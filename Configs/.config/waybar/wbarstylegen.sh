#!/usr/bin/env sh


# detect hypr theme and initialize variables

src_file="$HOME/.config/hypr/themes/theme.conf"
in_file=`echo $(readlink "$src_file") | awk -F "/" '{print $NF}' | cut -d '.' -f 1`
in_file="$HOME/.config/waybar/themes/${in_file}.css"
out_file="$HOME/.config/waybar/style.css"


# override waybar fonts

#fnt_size=`awk '{if($6=="font-name") print $NF}' $src_file | sed "s/'//g"`
fnt_size=`gsettings get org.gnome.desktop.interface font-name | awk '{gsub(/'\''/,""); print $NF}'`
sed "/font-size: /c\    font-size: ${fnt_size}px;" $in_file > $out_file


# override border radius

hypr_border=`awk -F '=' '{if($1~" rounding ") print $2}' $src_file | sed 's/ //g'`
if [ "$hypr_border" == "0" ] ; then
    sed -i "/border-radius: /c\    border-radius: 0px;" $out_file
fi


# restart waybar

killall waybar
waybar > /dev/null 2>&1 &
# killall -SIGUSR2 waybar

