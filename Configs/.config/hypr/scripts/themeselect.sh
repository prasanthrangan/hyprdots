#!/usr/bin/env sh

## set variables ##
BaseDir=`dirname $(realpath $0)`
ThemeCtl="$HOME/.config/swww/wall.ctl"
ThumbDir="$HOME/.config/swww/Themes-Ctl"
RofiConf="$HOME/.config/rofi/themeselect.rasi"
ThemeSet="$HOME/.config/hypr/themes/theme.conf"


## show and apply theme ##
if [ -z "$1" ] ; then

    hypr_border=`awk -F '=' '{if($1~" rounding ") print $2}' $ThemeSet | sed 's/ //g'`
    elem_border=$(( hypr_border * 5 ))
    icon_border=$(( elem_border - 5 ))
    r_override="element {border-radius: ${elem_border}px;} element-icon {border-radius: ${icon_border}px;}"

    ThemeSel=$(cat $ThemeCtl | while read line
    do
        thm=`echo $line | cut -d '|' -f 2`
        wal=`echo $line | cut -d '|' -f 3`
        echo -en "$thm\x00icon\x1f$ThumbDir/${thm}.png\n"
    done | rofi -dmenu -theme-str "${r_override}" -config $RofiConf)

    if [ ! -z $ThemeSel ] ; then
        ${BaseDir}/themeswitch.sh -s $ThemeSel
    fi

## regenerate thumbnails ##
elif [ "$1" == "T" ] ; then

    echo "refreshing thumbnails..."
    cat $ThemeCtl | while read line
    do
        thm=`echo $line | cut -d '|' -f 2`
        wal=`echo $line | cut -d '|' -f 3`
        wal=`eval echo $wal`

        echo "croping image from wallpaper $ThumbDir/${thm}.png..."
        convert $wal -thumbnail 500x500^ -gravity center -extent 500x500 $ThumbDir/${thm}.png
        #convert $wal -gravity Center -crop 1080x1080+0+0 $ThumbDir/${thm}.png
        #echo "applying rounded corner mask and generating $ThumbDir/${thm}.png..."
        #convert -size 1080x1080 xc:none -draw "roundrectangle 0,0,1080,1080,80,80" $ThumbDir/roundedmask.png
        #convert $ThumbDir/${thm}_tmp.png -matte $ThumbDir/roundedmask.png -compose DstIn -composite $ThumbDir/${thm}.png
    done

fi

