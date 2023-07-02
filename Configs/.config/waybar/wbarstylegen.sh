#!/usr/bin/env sh


# detect hypr theme and initialize variables

waybar_dir=`dirname $(realpath $0)`
in_file="$waybar_dir/modules/style.css"
out_file="$waybar_dir/style.css"
src_file="$HOME/.config/hypr/themes/theme.conf"
export cur_theme=`echo $(readlink "$src_file") | awk -F "/" '{print $NF}' | cut -d '.' -f 1`


# calculate height from control file or monitor res

b_height=`grep '^1|' $waybar_dir/config.ctl | cut -d '|' -f 2`

if [ -z $b_height ] || [ "$b_height" == "0" ]; then
    y_monres=`cat /sys/class/drm/*/modes | head -1 | cut -d 'x' -f 2`
    b_height=$(( y_monres*3/100 ))
fi


# calculate values sbased on height and generate theme style

export b_radius=$(( b_height*40/100 ))
export w_radius=$(( b_height*30/100 ))
export e_margin=$(( b_height*30/100 ))
export g_paddin=$(( b_height*15/100 ))
export g_margin=$(( g_paddin*90/100 ))
export w_paddin=$(( g_margin*90/100 ))
export w_margin=$(( g_margin*90/100 ))
export w_padact=$(( b_height*40/100 ))
envsubst < $in_file > $out_file


# override rounded couners

hypr_border=`awk -F '=' '{if($1~" rounding ") print $2}' $src_file | sed 's/ //g'`
if [ "$hypr_border" == "0" ] ; then
    sed -i "/border-radius: /c\    border-radius: 0px;" $out_file
fi


# override waybar font size based on gsettings

#fnt_size=`awk '{if($6=="font-name") print $NF}' $src_file | sed "s/'//g"`
fnt_size=`gsettings get org.gnome.desktop.interface font-name | awk '{gsub(/'\''/,""); print $NF}'`
sed -i "/font-size: /c\    font-size: ${fnt_size}px;" $out_file


# restart waybar

killall waybar
waybar > /dev/null 2>&1 &
# killall -SIGUSR2 waybar


