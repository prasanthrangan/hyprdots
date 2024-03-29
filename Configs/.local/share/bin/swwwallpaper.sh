#!/usr/bin/env sh


#// lock instance

lockFile="/tmp/hyrpdots$(id -u)swwwallpaper.lock"
[ -e "$lockFile" ] && echo "An instance of the script is already running..." && exit 1
touch "${lockFile}"
trap 'rm -f ${lockFile}' EXIT


#// define functions

Wall_Update()
{
    if [ ! -d "${thmbDir}" ] ; then
        mkdir -p "${thmbDir}"
    fi

    local x_wall="$1"
    local x_update="${x_wall/$HOME/"~"}"

    get_hashmap "${x_wall}"
    echo ":: ${walList[0]} :: ${wallHash[0]}"
    local cacheImg="${wallHash[0]}"
    "${scrDir}/swwwallbash.sh" "${x_wall}" &

    if [ ! -f "${thmbDir}/${cacheImg}.sqre" ] ; then
        convert -strip "${x_wall}"[0] -thumbnail 500x500^ -gravity center -extent 500x500 "${thmbDir}/${cacheImg}.sqre" &
    fi

    if [ ! -f "${thmbDir}/${cacheImg}.thmb" ] ; then
        convert -strip -resize 1000 -gravity center -extent 1000 -quality 50 "${x_wall}"[0] "${thmbDir}/${cacheImg}.thmb" &
    fi

    if [ ! -f "${thmbDir}/${cacheImg}.blur" ] ; then
        convert -strip -scale 10% -blur 0x3 -resize 100% "${x_wall}"[0] "${thmbDir}/${cacheImg}.blur" &
    fi

    wait
    awk -F '|' -v thm="${curTheme}" -v wal="${x_update}" '{OFS=FS} {if($2==thm)$NF=wal;print$0}' "${themeCtl}" > "${scrDir}/tmp" && mv "${scrDir}/tmp" "${themeCtl}"
    ln -fs "${x_wall}" "${wallSet}"
    ln -fs "${dcolDir}/${cacheImg}.dcol" "${wallDcl}"
    ln -fs "${thmbDir}/${cacheImg}.sqre" "${wallSqr}"
    ln -fs "${thmbDir}/${cacheImg}.thmb" "${wallTmb}"
    ln -fs "${thmbDir}/${cacheImg}.blur" "${wallBlr}"
}

Wall_Change()
{
    local x_switch=$1

    for (( i=0 ; i<${#walList[@]} ; i++ ))
    do
        if [ "${walList[i]}" == "${fullPath}" ] ; then

            if [ $x_switch == 'n' ] ; then
                nextIndex=$(( (i + 1) % ${#walList[@]} ))
            elif [ $x_switch == 'p' ] ; then
                nextIndex=$(( i - 1 ))
            fi

            Wall_Update "${walList[nextIndex]}"
            break
        fi
    done
}

Wall_Set()
{
    if [ -z "${xtrans}" ] ; then
        xtrans="grow"
    fi

    swww img "$(readlink "${wallSet}")" \
    --transition-bezier .43,1.19,1,.4 \
    --transition-type "${xtrans}" \
    --transition-duration 0.7 \
    --transition-fps 60 \
    --invert-y \
    --transition-pos "$( hyprctl cursorpos )"
}


#// set variables

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
wallSet="${wallDir}/wall.set"
wallBlr="${wallDir}/wall.blur"
wallTmb="${wallDir}/wall.thmb"
wallSqr="${wallDir}/wall.sqre"
wallDcl="${wallDir}/wall.dcol"
ctlLine="$(grep '^1|' ${themeCtl})"

if [ "$(echo "${ctlLine}" | wc -l)" -ne "1" ] ; then
    echo "ERROR : ${themeCtl} Unable to fetch theme..."
    exit 1
fi

curTheme=$(echo "${ctlLine}" | awk -F '|' '{print $2}')
fullPath=$(echo "${ctlLine}" | awk -F '|' '{print $NF}' | sed "s+~+$HOME+")
wallName=$(basename "${fullPath}")
wallPath=$(dirname "${fullPath}")
get_hashmap "${wallPath}"

if [ ! -f "${fullPath}" ] ; then
    if [ -d "${wallDir}" ] ; then
        wallPath="${wallDir}/${curTheme}"
        get_hashmap "${wallPath}"
        fullPath="${walList[0]}"
    else
        echo "ERROR: wallpaper ${fullPath} not found..."
        exit 1
    fi
fi


#// evaluate options

while getopts "nps:" option ; do
    case $option in
    n ) # set next wallpaper
        xtrans="grow"
        Wall_Change n ;;
    p ) # set previous wallpaper
        xtrans="outer"
        Wall_Change p ;;
    s ) # set input wallpaper
        if [ -f "$OPTARG" ] ; then
            Wall_Update "$OPTARG"
        fi ;;
    * ) # invalid option
        echo "n : set next wall"
        echo "p : set previous wall"
        echo "s : set input wallpaper"
        exit 1 ;;
    esac
done


#// check swww daemon and set wall

swww query
if [ $? -ne 0 ] ; then
    swww-daemon --format xrgb &
    sleep 1
    swww query
    if [ $? -ne 0 ] ; then
        swww clear-cache
        swww clear 
        swww init
        sleep 1
        swww query
        if [ $? -ne 0 ] ; then
            swww clear-cache
            swww clear 
            swww-daemon --format xrgb &
        fi
    fi
fi

Wall_Set

