#!/usr/bin/env sh


#// set variables

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
TgtScr="$scrDir/globalcontrol.sh"
rofiConf="${confDir}/rofi/wallbash.rasi"
wallbashModes=("theme" "auto" "dark" "light")


#// rofi select mode

rofi_wallbash()
{
    [[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10
    r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
    elem_border=$(( hypr_border * 4 ))
    r_override="window{border-radius:${elem_border}px;} element{border-radius:${elem_border}px;}"
    rofiSel=$(parallel echo {} ::: "${wallbashModes[@]}" | rofi -dmenu -theme-str "${r_scale}" -theme-str "${r_override}" -config "${rofiConf}" -select "${wallbashModes[${enableWallDcol}]}")
    if [ ! -z "${rofiSel}" ] ; then
        setMode="$(parallel --link echo {} ::: "${!wallbashModes[@]}" ::: "${wallbashModes[@]}" ::: "${rofiSel}" | awk '{if ($2 == $3) print $1}')"
    else
        exit 0
    fi
}


#// switch mode

step_wallbash()
{
    for i in "${!wallbashModes[@]}" ; do
        if [ "${enableWallDcol}" == "${i}" ] ; then
            if [ "${1}" == "n" ] ; then
                setMode=$(( (i + 1) % ${#wallbashModes[@]} ))
            elif [ "${1}" == "p" ] ; then
                setMode=$(( i - 1 ))
            fi
            break
        fi
    done
}


#// apply wallbash mode

case "${1}" in
    m|-m|--menu) rofi_wallbash ;;
    n|-n|--next) step_wallbash n ;;
    p|-p|--prev) step_wallbash p ;;
    *)  step_wallbash n ;;
esac

export reload_flag=1
[[ "${setMode}" -lt 0 ]] && setMode=$((${#wallbashModes[@]} - 1))
set_conf "enableWallDcol" "${setMode}"
"${scrDir}/themeswitch.sh"
notify-send -a "t1" -i "${icoDir}/hyprdots.png" " ${wallbashModes[setMode]} mode"

