#!/usr/bin/env sh

if [ -z "$XDG_PICTURES_DIR" ] ; then
    XDG_PICTURES_DIR="$HOME/Pictures/Screenshots"
fi

if [ -z "$XDG_VIDEOS_DIR" ] ; then
    XDG_VIDEOS_DIR="$HOME/Videos/ScreenRecs"
fi


ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh
swpy_dir="$HOME/.config/swappy"

IMG_dir="${2:-$XDG_PICTURES_DIR}"
IMG_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')

VID_dir="${2:-$XDG_VIDEOS_DIR}"
VID_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenrec.mp4')

mkdir -p $IMG_dir

case $1 in
p)  grim $IMG_dir/$IMG_file ;;

s)  mkdir -p $swpy_dir
    echo -e "[Default]\nsave_dir=$save_dir\nsave_filename_format=$save_file" > $swpy_dir/config
    temp_screenshot="/tmp/fullscreen_screenshot.png"
    hyprctl keyword animations:enabled 0
    # Capture the full screen of the active monitor
    grim -o "$(hyprctl -j activeworkspace | jq -r '.monitor')" "$temp_screenshot"
    # Open the screenshot in imv (in the background)
    imv -f "$temp_screenshot" &
    IMV_PID=$!
    # Capture the desired region
    screenshot_region=$(slurp)
    sleep 0.5
    kill $IMV_PID
    grim -g "$screenshot_region" - | swappy -f -
    hyprctl keyword animations:enabled 1
    rm "$temp_screenshot" ;;
	
*)  echo "...valid options are..."
    echo "p : print screen to $IMG_dir"
    echo "s : snip current screen to $IMG_dir"   
    exit 1 ;;

esac

if [ -f "$IMG_dir/$IMG_file" ] ; then
    dunstify $ncolor "theme" -a "saved in $IMG_dir" -i "$IMG_dir/$IMG_file" -r 91190 -t 2200
fi





















 '


video_path="$HOME/Videos/Screenrecordings"
image_path="$HOME/Pictures/Screenshots/"

wf-recorder_check() {
	if pgrep -x "wf-recorder" > /dev/null; then
			pkill -INT -x wf-recorder
			notify-send "Stopping all instances of wf-recorder" "$(cat /tmp/recording.txt)"
			wl-copy < "$(cat /tmp/recording.txt)"
			exit 0
	fi
}

wf-recorder_check

#SELECTION=$(echo -e "Screenshot Selection\nscreenshot DP-1\nscreenshot DP-2\nscreenshot both screens\nRecord Selection\nrecord DP-1\nrecord DP-2" | fuzzel -d -p "󰄀 " -w 25 -l 6)


SELECTION=$(echo -e "Screenshot Selection\nscreenshot DP-1\nscreenshot DP-2\nscreenshot both screens\nRecord Selection\nrecord DP-1\nrecord DP-2" | rofi -dmenu -p "󰄀 ")


VID="$video_path/$(date +%Y-%m-%d_%H-%m-%s).png"
IMG="$image_path/$(date +%Y-%m-%d_%H-%m-%s).mp4"

@@
case "$SELECTION" in
	"Screenshot Selection")
		grim -g "$(slurp)" "$IMG"
		wl-copy < "$IMG"
		notify-send "Screenshot Taken" "${IMG}"
		;;
		#! I can Add auto scan here
	"screenshot DP-1")
		grim -c -o DP-1 "$IMG"
		wl-copy < "$IMG"
		notify-send "Screenshot Taken" "${IMG}"
		;;
	"screenshot DP-2")
		grim -c -o DP-2 "$IMG"
		wl-copy < "$IMG"
		notify-send "Screenshot Taken" "${IMG}"
		;;
	"screenshot both screens")
		grim -c -o DP-1 "${IMG//.png/-DP-1.png}"
		grim -c -o DP-2 "${IMG//.png/-DP-2.png}"
		montage "${IMG//.png/-DP-1.png}" "${IMG//.png/-DP-2.png}" -tile 2x1 -geometry +0+0 "$IMG" 
		wl-copy < "$IMG"
		rm "${IMG//.png/-DP-1.png}" "${IMG/.png/-DP-2.png}"
		notify-send "Screenshot Taken" "${IMG}"
		;;
		#!===================================


	"Record Selection")
		echo "$VID" > /tmp/recording.txt
		wf-recorder -a -g "$(slurp)" -f "$VID" &>/dev/null
		;;


				#! I can Add auto scan here
	"record DP-1")
		echo "$VID" > /tmp/recording.txt
		wf-recorder -a -o DP-1 -f "$VID" &>/dev/null
		;;
	"record DP-2")
		echo "$VID" > /tmp/recording.txt
	wf-recorder -a -o DP-2 -f "$VID" &>/dev/null
	;;
			#!===================================

"record both screens")
	notify-send "recording both screens is not functional"
	;;

*)

	notify-send "!!!!!!!!!"



	;;
esac

'