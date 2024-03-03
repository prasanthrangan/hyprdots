#!/usr/bin/env sh

# set variables
MODE=${1:-5}
ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
ThemeSet="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/themes/theme.conf"
RofiConf="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/steam/gamelauncher_${MODE}.rasi"

# set rofi override
elem_border=$(( hypr_border * 2 ))
icon_border=$(( elem_border - 3 ))
r_override="element{border-radius:${elem_border}px;} element-icon{border-radius:${icon_border}px;}"
monitor_res=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | "\(.width)x\(.height)"')

#? This block ensures that the image is fitted correctly in each monitor
if [ "${MODE}" = 5 ]; then
     BG=${ConfDir}/rofi/assets/steamdeck_holographic.png
     BGbk=${ConfDir}/rofi/assets/.steamdeck_holographic_bak.png
     BGfx=${ConfDir}/rofi/assets/.steamdeck_holographic_${monitor_res}.png
 [ ! -e "${BGbk}" ] && cp "${BG}" "${BGbk}"
 [ ! -e "${BGfx}"  ] && convert "${BG}" -resize "${monitor_res}" -background none -gravity center -extent "${monitor_res}" "${BGfx}"
     ln -sf "${BGfx}" "${BG}"
fi

fn_steam() {
# check steam mount paths
SteamPaths=`grep '"path"' $SteamLib | awk -F '"' '{print $4}'`
ManifestList=`find $SteamPaths/steamapps/ -type f -name "appmanifest_*.acf" 2>/dev/null`

# read intalled games
GameList=$(echo "$ManifestList" | while read acf
do
    appid=`grep '"appid"' $acf | cut -d '"' -f 4`
    if [ -f ${SteamThumb}/${appid}_library_600x900.jpg ] ; then
        game=`grep '"name"' $acf | cut -d '"' -f 4`
        echo "$game|$appid"
    else
        continue
    fi
done | sort)

# launch rofi menu
RofiSel=$( echo "$GameList" | while read acf
do
    appid=`echo $acf | cut -d '|' -f 2`
    game=`echo $acf | cut -d '|' -f 1`
    echo -en "$game\x00icon\x1f${SteamThumb}/${appid}_library_600x900.jpg\n"
done | rofi -dmenu -theme-str "${r_override}" -config $RofiConf)

# launch game
if [ ! -z "$RofiSel" ] ; then
    launchid=`echo "$GameList" | grep "$RofiSel" | cut -d '|' -f 2`
    ${steamlaunch} -applaunch "${launchid} [gamemoderun %command%]" &
    dunstify "t1" -a "Launching ${RofiSel}..." -i ${SteamThumb}/${launchid}_header.jpg -r 91190 -t 2200
fi
}

fn_lutris() {
icon_path="${HOME}/.local/share/lutris/coverart"
[ ! -e "${icon_path}" ] && icon_path="${HOME}/.cache/lutris/coverart"
meta_data="/tmp/lutrisgames.json"

# Retrieve the list of games from Lutris in JSON format
#TODO Only call this if new apps are installed...
 [ ! -s "${meta_data}" ] &&   lutris -j -l 2> /dev/null | jq --arg icons "$icon_path/" --arg prefix ".jpg" '.[] |= . + {"select": (.name + "\u0000icon\u001f" + $icons + .slug + $prefix)}' > "${meta_data}"

CHOICE=$(jq -r '.[].select' "${meta_data}" | rofi -dmenu -p Lutris  -theme-str "${r_override}" -config ${RofiConf})
[ -z "$CHOICE" ] && exit 0
	SLUG=$(jq -r --arg choice "$CHOICE" '.[] | select(.name == $choice).slug' "${meta_data}"  )
	exec xdg-open "lutris:rungame/${SLUG}"
}

if ! pkg_installed lutris  || echo "$*" | grep -q "steam" ; then
    # set steam library
    if pkg_installed steam ; then
        SteamLib="${XDG_DATA_HOME:-$HOME/.local/share}/Steam/config/libraryfolders.vdf"
        SteamThumb="${XDG_DATA_HOME:-$HOME/.local/share}/Steam/appcache/librarycache"
        steamlaunch="steam"
    else
        SteamLib="$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/config/libraryfolders.vdf"
        SteamThumb="$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/appcache/librarycache"
        steamlaunch="flatpak run com.valvesoftware.Steam"
    fi
    
    if [ ! -f $SteamLib ] || [ ! -d $SteamThumb ] ; then
        dunstify "t1" -a "Steam library not found!" -r 91190 -t 2200
        exit 1
    fi
    fn_steam
else
    fn_lutris
fi
