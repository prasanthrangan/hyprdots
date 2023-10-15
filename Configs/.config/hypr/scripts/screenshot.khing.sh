#!/usr/bin/env sh

if [ -z "$XDG_PICTURES_DIR" ] ; then
    XDG_PICTURES_DIR="$HOME/Pictures"
fi

if [ -z "$XDG_VIDEOS_DIR" ] ; then
    XDG_VIDEOS_DIR="$HOME/Videos"
fi

ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh
swpy_dir="$HOME/.config/swappy"
IMG_dir="${2:-$XDG_PICTURES_DIR/Screenshots}"
save_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')

VID_dir="${2:-$XDG_VIDEOS_DIR/Recordings}"
VID_file=$(date +'%y%m%d_%Hh%Mm%Ss_recording.mp4')
mkdir -p $IMG_dir
mkdir -p $VID_dir

 printScreen () {
 grimblast copysave output $IMG_dir/$save_file
}

screenShot () {
 mkdir -p $swpy_dir
    echo -e "[Default]\nsave_dir=$IMG_dir\nsave_filename_format=$save_file" > $swpy_dir/config
    temp="/tmp/screenshot.png"
    grimblast  --freeze copysave area $temp
     swappy -f $temp
    rm "$temp"
}

screenRec () {
    if pgrep -x "wl-screenrec" > /dev/null
    then
    pkill -x "wl-screenrec" 
    else
        thumb="/tmp/wl-screenrecthumbnail.png"
        wl-screenrec -f $VID_dir/$VID_file
    fi   
}

screenCat () { 
    if pgrep -x "wl-screenrec" > /dev/null
    then
    pkill -x "wl-screenrec" 
    else
        thumb="/tmp/wl-screenrecthumbnail.png"
        nail=$(slurp)
        grim -g "$nail" $thumb
         wl-screenrec -g "$nail" -f $VID_dir/$VID_file
fi 
}

help () {
        
    echo "...valid options are..."
    echo "p : print screen to $IMG_dir"
    echo "s : snip current screen to $IMG_dir"
    echo "c : record a part of a screen"
    echo "w : record active window   "
    exit 1
}





case $1 in
"p")  
    printScreen ;;
"s")
    screenShot  ;;
"w") 
    screenRec ;;
"c") 
    screenCat  ;;
*)  
    help     ;;
esac


if [ -f "$IMG_dir/$save_file" ] ; then
    dunstify $ncolor "theme" -a "Saved in $IMG_dir" -i "$IMG_dir/$save_file" -r 91190 -t 3200
fi

if [ -f "$VID_dir/$VID_file" ] ; then
    dunstify $ncolor "theme" -a "Saved in $VID_dir" -i "$thumb" -r 91190 -t 3200
    rm "$thumb"
fi


