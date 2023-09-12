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


# calculate values based on height and generate theme style

export b_radius=$(( b_height*70/100 ))   # block rad 90% of height (type1)
export c_radius=$(( b_height*25/100 ))   # block rad 25% of height {type2}
export e_margin=$(( b_height*30/100 ))   # block margin 30% of height
export e_paddin=$(( b_height*10/100 ))   # block padding 10% of height
export g_margin=$(( b_height*14/100 ))   # module margin 14% of height
export g_paddin=$(( b_height*15/100 ))   # module padding 15% of height
export w_radius=$(( b_height*30/100 ))   # workspace rad 30% of height
export w_margin=$(( b_height*10/100 ))   # workspace margin 10% of height
export w_paddin=$(( b_height*10/100 ))   # workspace padding 10% of height
export w_padact=$(( b_height*40/100 ))   # workspace active padding 40% of height
export s_fontpx=$(( b_height*38/100 ))   # font size 38% of height

if [ $b_height -lt 30 ] ; then
    export e_paddin=0
fi
if [ $s_fontpx -lt 10 ] ; then
    export s_fontpx=10
fi

envsubst < $in_file > $out_file


# override rounded couners

hypr_border=`awk -F '=' '{if($1~" rounding ") print $2}' $src_file | sed 's/ //g'`
if [ "$hypr_border" == "0" ] ; then
    sed -i "/border-radius: /c\    border-radius: 0px;" $out_file
fi


# restart waybar

killall waybar
waybar > /dev/null 2>&1 &
# killall -SIGUSR2 waybar


