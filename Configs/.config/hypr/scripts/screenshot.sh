#!/usr/bin/env sh

if [ -z "$XDG_PICTURES_DIR" ] ; then
    XDG_PICTURES_DIR="$HOME/Pictures"
fi

save_dir="${2:-$XDG_PICTURES_DIR}"
save_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')
ncolor="-h string:bgcolor:#343d46 -h string:fgcolor:#c0c5ce -h string:frcolor:#c0c5ce"

if [ ! -d "$save_dir" ] ; then
    mkdir -p $save_dir
fi

case $1 in
p) grim $save_dir/$save_file ;;
s) grim -g "$(slurp)" - | swappy -f - ;;
*)  echo "...valid options are..."
    echo "p : print screen to $save_dir"
    echo "s : snip current screen to $save_dir"   
    exit 1 ;;
esac

if [ -f "$save_dir/$save_file" ] ; then
    dunstify $ncolor "theme" -a "saved in $save_dir" -i "$save_dir/$save_file" -r 91190 -t 2200
fi
