#!/usr/bin/env sh


# detect hypr theme and initialize variables

ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
waybar_dir="${XDG_CONFIG_HOME:-$HOME/.config}/waybar"
modules_dir="$waybar_dir/modules"
conf_ctl="$waybar_dir/config.ctl"
in_file="$waybar_dir/modules/style.css"
out_file="$waybar_dir/style.css"
src_file="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/themes/theme.conf"

if [ "$EnableWallDcol" -eq 1 ] ; then
    ln -fs $waybar_dir/themes/Wall-Dcol.css $waybar_dir/themes/theme.css
    reload_flag=1
elif [ $(readlink $waybar_dir/themes/theme.css) != "$waybar_dir/themes/${gtkTheme}.css" ] ; then
    ln -fs $waybar_dir/themes/${gtkTheme}.css $waybar_dir/themes/theme.css
    reload_flag=1
fi

# reload forced with option
DEBUG=0
while [ "$1" != "" ]; do
    case "$1" in 
        r|-r|--restart) reload_flag=1 ;; # reload forced with option
        -d|--debug) DEBUG=1 ;; # debug mode
    esac
    shift
done

debugPrint() {
    if [ "$DEBUG" -eq 1 ]; then
        echo -e "$1" | tee -a "/tmp/$(basename $0).log"
    fi
}

# calculate height from control file or monitor res

# Disable for multiscreen the size from from the lowest screen size simce is the best way
# b_height=`grep '^1|' $conf_ctl | cut -d '|' -f 2` # get the size of the 1st waybar config

# get b_height from wbarconfgen.sh or build it from hyprctl
if [ -z $b_height ] || [ "$b_height" == "0" ]; then
    # can get the res from hyprctl monitors best than all res of all monitors
    # y_monres=`cat /sys/class/drm/*/modes | head -1 | cut -d 'x' -f 2`   # Get the hightest resolution of the first monitor
    # y_monres=`cat /sys/class/drm/*/modes | sed '/^$/d' | sort -t 'x' -k2 -nr | head -1 | cut -d 'x' -f 2` # Get the hightest resolution of all monitors
    y_monres=$(hyprctl monitors -j | jq -s '.[] | .[] | .height' | sort -n | head -1) # return the height of the smallest monitor
    b_height=$(( y_monres*3/100 ))  # good for 1k not good for 4k (too big)
fi


# calculate values based on height

export b_radius=$(( b_height*70/100 ))   # block rad 70% of height (type1)
export c_radius=$(( b_height*25/100 ))   # block rad 25% of height {type2}
export t_radius=$(( b_height*25/100 ))   # tooltip rad 25% of height
export e_margin=$(( b_height*30/100 ))   # block margin 30% of height
export e_paddin=$(( b_height*10/100 ))   # block padding 10% of height
export g_margin=$(( b_height*14/100 ))   # module margin 14% of height
export g_paddin=$(( b_height*20/100 ))   # module padding 20% of height
export w_radius=$(( b_height*30/100 ))   # workspace rad 30% of height
export w_margin=$(( b_height*10/100 ))   # workspace margin 10% of height
export w_paddin=$(( b_height*10/100 ))   # workspace padding 10% of height
export w_padact=$(( b_height*40/100 ))   # workspace active padding 40% of height

# disabling for multiscreen, bar size and auto font size since is the best way
# export s_fontpx=$(( b_height*38/100 ))   # font size 38% of height

if [ $b_height -lt 30 ] ; then
    export e_paddin=0
fi
# if [ $s_fontpx -lt 10 ] ; then
#     export s_fontpx=10
# fi


# adjust values for vert/horz

export w_position=`grep '^1|' $conf_ctl | cut -d '|' -f 3`
case ${w_position} in
    top|bottom)
        export x1g_margin=${g_margin}
        export x2g_margin=0
        export x3g_margin=${g_margin}
        export x4g_margin=0
        export x1rb_radius=0
        export x2rb_radius=${b_radius}
        export x3rb_radius=${b_radius}
        export x4rb_radius=0
        export x1lb_radius=${b_radius}
        export x2lb_radius=0
        export x3lb_radius=0
        export x4lb_radius=${b_radius}
        export x1rc_radius=0
        export x2rc_radius=${c_radius}
        export x3rc_radius=${c_radius}
        export x4rc_radius=0
        export x1lc_radius=${c_radius}
        export x2lc_radius=0
        export x3lc_radius=0
        export x4lc_radius=${c_radius}
        export x1="top"
        export x2="bottom"
        export x3="left" 
        export x4="right" ;;
    left|right)
        export x1g_margin=0
        export x2g_margin=${g_margin}
        export x3g_margin=0
        export x4g_margin=${g_margin}
        export x1rb_radius=0
        export x2rb_radius=0
        export x3rb_radius=${b_radius}
        export x4rb_radius=${b_radius}
        export x1lb_radius=${b_radius}
        export x2lb_radius=${b_radius}
        export x3lb_radius=0
        export x4lb_radius=0
        export x1rc_radius=0
        export x2rc_radius=${c_radius}
        export x3rc_radius=${c_radius}
        export x4rc_radius=0
        export x1lc_radius=${c_radius}
        export x2lc_radius=0
        export x3lc_radius=0
        export x4lc_radius=${c_radius}
        export x1="left"
        export x2="right"
        export x3="top" 
        export x4="bottom" ;;
esac


# list modules and generate theme style

export modules_ls=$(grep -m 1 '".*.": {'  --exclude="$modules_dir/footer.jsonc" $modules_dir/*.jsonc | cut -d '"' -f 2 | awk -F '/' '{ if($1=="custom") print "#custom-"$NF"," ; else print "#"$NF","}')
envsubst < $in_file > $out_file


# override rounded couners

hypr_border=`awk -F '=' '{if($1~" rounding ") print $2}' $src_file | sed 's/ //g'`
if [ "$hypr_border" == "0" ] ; then
    sed -i "/border-radius: /c\    border-radius: 0px;" $out_file
fi


# restart waybar

if [ "$reload_flag" == "1" ] ; then
    killall waybar
    nohup waybar > /dev/null 2>&1 &
    # killall -SIGUSR2 waybar
    debugPrint "Restarted waybar..."
fi

