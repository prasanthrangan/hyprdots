#!/usr/bin/env sh


#// set variables

export scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
export thmbDir
export dcolDir
[ -d "${hydeThemeDir}" ] && cacheIn="${hydeThemeDir}" || exit 1
[ -d "${thmbDir}" ] || mkdir -p "${thmbDir}"
[ -d "${dcolDir}" ] || mkdir -p "${dcolDir}"


#// define functions

fn_wallcache()
{
    local x_hash="${1}"
    local x_wall="${2}"
    [ ! -e "${thmbDir}/${x_hash}.thmb" ] && convert -strip -resize 1000 -gravity center -extent 1000 -quality 90 "${x_wall}"[0] "${thmbDir}/${x_hash}.thmb"
    [ ! -e "${thmbDir}/${x_hash}.sqre" ] && convert -strip "${x_wall}"[0] -thumbnail 500x500^ -gravity center -extent 500x500 "${thmbDir}/${x_hash}.sqre"
    [ ! -e "${thmbDir}/${x_hash}.blur" ] && convert -strip -scale 10% -blur 0x3 -resize 100% "${x_wall}"[0] "${thmbDir}/${x_hash}.blur"
    [ ! -e "${dcolDir}/${x_hash}.dcol" ] && "${scrDir}/wallbash.sh" "${x_wall}" &> /dev/null
    [ "$(wc -l < "${dcolDir}/${x_hash}.dcol")" -ne 89 ] && "${scrDir}/wallbash.sh" "${x_wall}" &> /dev/null
}

fn_wallcache_force()
{
    local x_hash="${1}"
    local x_wall="${2}"
    convert -strip -resize 1000 -gravity center -extent 1000 -quality 90 "${x_wall}"[0] "${thmbDir}/${x_hash}.thmb"
    convert -strip "${x_wall}"[0] -thumbnail 500x500^ -gravity center -extent 500x500 "${thmbDir}/${x_hash}.sqre"
    convert -strip -scale 10% -blur 0x3 -resize 100% "${x_wall}"[0] "${thmbDir}/${x_hash}.blur"
    "${scrDir}/wallbash.sh" "${x_wall}" &> /dev/null
}

export -f fn_wallcache
export -f fn_wallcache_force


#// evaluate options

while getopts "w:t:f" option ; do
    case $option in
    w ) # generate cache for input wallpaper
        if [ -z "${OPTARG}" ] || [ ! -f "${OPTARG}" ] ; then
            echo "Error: Input wallpaper \"${OPTARG}\" not found!"
            exit 1
        fi
        cacheIn="${OPTARG}"
        ;;
    t ) # generate cache for input theme
        cacheIn="$(dirname "${hydeThemeDir}")/${OPTARG}"
        if [ ! -d "${cacheIn}" ] ; then
            echo "Error: Input theme \"${OPTARG}\" not found!"
            exit 1
        fi
        ;;
    f ) # full cache rebuild
        cacheIn="$(dirname "${hydeThemeDir}")"
        mode="_force"
        ;;
    * ) # invalid option
        echo "... invalid option ..."
        echo "$(basename "${0}") -[option]"
        echo "w : generate cache for input wallpaper"
        echo "t : generate cache for input theme"
        echo "f : full cache rebuild"
        exit 1 ;;
    esac
done


#// generate cache

get_hashmap "${cacheIn}"
parallel --bar --link "fn_wallcache${mode}" ::: "${wallHash[@]}" ::: "${walList[@]}"

