#!/usr/bin/env sh

if [ -z "$XDG_PICTURES_DIR" ] ; then
    XDG_PICTURES_DIR="$HOME/Pictures"
fi

ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh
swpy_dir="$HOME/.config/swappy"
save_dir="${2:-$XDG_PICTURES_DIR}"
save_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')

mkdir -p $save_dir
mkdir -p $swpy_dir
echo -e "[Default]\nsave_dir=$save_dir\nsave_filename_format=$save_file" > $swpy_dir/config

function print_error
{
cat << "EOF"
    ./screenshot.sh <action>
    ...valid actions are...
        p : print current screen
        s : snip current screen
EOF
}

case $1 in
p)  grim $save_dir/$save_file ;;
s)  grim -g "$(slurp)" - | swappy -f - ;;
*)  print_error ;;
esac

if [ -f "$save_dir/$save_file" ] ; then
    dunstify "t1" -a "saved in $save_dir" -i "$save_dir/$save_file" -r 91190 -t 2200
fi

