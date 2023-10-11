#!/usr/bin/env sh

if [ -z "$XDG_PICTURES_DIR" ] ; then
    XDG_PICTURES_DIR="$HOME/Pictures/screenshots/"
fi

ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh
swpy_dir="$HOME/.config/swappy"
save_dir="${2:-$XDG_PICTURES_DIR}"
save_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')
mkdir -p $save_dir

temp_screenshot="/tmp/screenshot.png"
case $1 in
# print all outputs
p)  grimblast copysave screen $temp_screenshot && swappy -f $temp_screenshot ;;
# drag to manually snip an area / click on a window to print it
s)  mkdir -p $swpy_dir
    echo -e "[Default]\nsave_dir=$save_dir\nsave_filename_format=$save_file" > $swpy_dir/config
    grimblast  --freeze copysave area $temp_screenshot && swappy -f $temp_screenshot ;;
# print focused monitor
m)  grimblast copysave output $temp_screenshot && swappy -f $temp_screenshot ;;
*)  echo "...valid options are..."
    echo "p : print screen to $save_dir"
    echo "s : snip current screen to $save_dir"   
    exit 1 ;;
esac
rm "$temp_screenshot"


if [ -f "$save_dir/$save_file" ] ; then
    dunstify $ncolor "theme" -a "saved in $save_dir" -i "$save_dir/$save_file" -r 91190 -t 2200
fi
