#!/usr/bin/env sh

src_file="$HOME/.config/hypr/themes/theme.conf"

in_file=`echo $(readlink "$src_file") | awk -F "/" '{print $NF}' | cut -d '.' -f 1`
in_file="$HOME/.config/waybar/themes/${in_file}.css"

out_file="$HOME/.config/waybar/style.css"

fnt_size=`awk '{if($6=="font-name") print $8}' $src_file | sed "s/'//g"`

sed "/font-size: /c\    font-size: ${fnt_size}px;" $in_file > $out_file

hypr_border=`awk -F '=' '{if($1~" rounding ") print $2}' $src_file | sed 's/ //g'`
if [ "$hypr_border" == "0" ] ; then
    sed -i "/border-radius: /c\    border-radius: 0px;" $out_file
fi

#killall -SIGUSR2 waybar
killall waybar
waybar > /dev/null 2>&1 &

