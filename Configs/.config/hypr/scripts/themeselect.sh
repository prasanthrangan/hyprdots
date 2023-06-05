#!/usr/bin/env sh

## set variables ##
BaseDir=`dirname $(realpath $0)`
ConfDir="$HOME/.config"
ThemeCtl="$ConfDir/swww/wall.ctl"
ThumbDir="$ConfDir/swww/Themes-Ctl"
RofiConf="$ConfDir/rofi/themeselect.rasi"


## show and apply theme ##
if [ -z "$1" ] ; then

    ThemeSel=$(cat $ThemeCtl | while read line
    do
        thm=`echo $line | cut -d '|' -f 2`
        wal=`echo $line | cut -d '|' -f 3`
        echo -en "$thm\x00icon\x1f$ThumbDir/${thm}.png\n"
    done | rofi -dmenu -config $RofiConf)

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

        echo "croping image from wallpaper $ThumbDir/${thm}_tmp.png..."
        convert $wal -gravity Center -crop 1080x1080+0+0 $ThumbDir/${thm}_tmp.png
        echo "applying rounded corner mask and generating $ThumbDir/${thm}.png..."
        #convert -size 1080x1080 xc:none -draw "roundrectangle 0,0,1080,1080,80,80" $ThumbDir/roundedmask.png
        convert $ThumbDir/${thm}_tmp.png -matte $ThumbDir/roundedmask.png -compose DstIn -composite $ThumbDir/${thm}.png
        rm $ThumbDir/${thm}_tmp.png
    done

fi

