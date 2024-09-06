#!/usr/bin/env sh

# set variables
MODE=${1:-5}
scrDir=`dirname "$(realpath "$0")"`
source $scrDir/globalcontrol.sh
ThemeSet="${confDir}/hypr/themes/theme.conf"
RofiConf="${confDir}/rofi/steam/gamelauncher_${MODE}.rasi"

# set rofi override
elem_border=$(( hypr_border * 2 ))
icon_border=$(( elem_border - 3 ))
r_override="element{border-radius:${elem_border}px;} element-icon{border-radius:${icon_border}px;}"

fn_steam() {
# check steam mount paths
SteamPaths=`grep '"path"' $SteamLib | awk -F '"' '{print $4}'`
ManifestList=`find $SteamPaths/steamapps/ -type f -name "appmanifest_*.acf" 2>/dev/null`

# read installed games
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
    # dunstify "t1" -a "Launching ${RofiSel}..." -i ${SteamThumb}/${launchid}_header.jpg -r 91190 -t 2200
    notify-send -a "t1" -i "${SteamThumb}/${launchid}_header.jpg" "Launching ${RofiSel}..."

fi
}

fn_lutris() {
[ ! -e "${icon_path}" ] && icon_path="${HOME}/.local/share/lutris/coverart"
[ ! -e "${icon_path}" ] && icon_path="${HOME}/.cache/lutris/coverart"
meta_data="/tmp/hyprdots-$(id -u)-lutrisgames.json"

# Retrieve the list of games from Lutris in JSON format
#TODO Only call this if new apps are installed...
 # [ ! -s "${meta_data}" ] &&  
notify-send -a "t1" "Please wait... " -t 4000 

eval "${run_lutris}" -j -l 2> /dev/null| jq --arg icons "$icon_path/" --arg prefix ".jpg" '.[] |= . + {"select": (.name + "\u0000icon\u001f" + $icons + .slug + $prefix)}' > "${meta_data}"

[ ! -s "${meta_data}" ] && notify-send -a "t1" "Cannot Fetch Lutris Games!" && exit 1


CHOICE=$(jq -r '.[].select' "${meta_data}" | rofi -dmenu -p Lutris  -theme-str "${r_override}" -config "${RofiConf}" )
[ -z "$CHOICE" ] && exit 0
	SLUG=$(jq -r --arg choice "$CHOICE" '.[] | select(.name == $choice).slug' "${meta_data}"  )
    notify-send -a "t1" -i "${icon_path}/${SLUG}.jpg" "Launching ${CHOICE}..."
	exec xdg-open "lutris:rungame/${SLUG}"
}

# Handle if flatpak or pkgmgr
run_lutris=""
( flatpak list --columns=application | grep -q "net.lutris.Lutris" ) &&  run_lutris="flatpak run net.lutris.Lutris" ; icon_path="${HOME}/.var/app/net.lutris.Lutris/data/lutris/coverart/"
[ -z "${run_lutris}" ] &&  ( pkg_installed 'lutris' ) && run_lutris="lutris"

if [ -z "${run_lutris}" ] || echo "$*" | grep -q "steam" ; then
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
        notify-send -a "t1" "Steam library not found!"
        exit 1
    fi
    fn_steam
else
    fn_lutris
fi
