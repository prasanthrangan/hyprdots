#!/usr/bin/env sh

#// Set variables

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
roconf="${confDir}/rofi/styles/style_${rofiStyle}.rasi"

#// Check if rofiScale is numeric, set default if not

[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10

#// If the specified rofi config file does not exist, find the latest one

if [ ! -f "${roconf}" ]; then
    roconf="$(find "${confDir}/rofi/styles" -type f -name "style_*.rasi" | sort -t '_' -k 2 -n | head -1)"
fi

#// Rofi action

case "${1}" in
    d | --drun)
        r_mode="drun"
        ;; 
    w | --window)
        r_mode="window"
        ;;
    f | --filebrowser)
        r_mode="filebrowser"
        ;;
    h | --help)
        echo -e "$(basename "${0}") [action]"
        echo "d :  drun mode"
        echo "w :  window mode"
        echo "f :  filebrowser mode,"
        exit 0
        ;;
    *)
        r_mode="drun"
        ;;
esac

#// Set overrides

wind_border=$(( hypr_border * 3 ))
[ "${hypr_border}" -eq 0 ] && elem_border="10" || elem_border=$(( hypr_border * 2 ))
r_override="window {border: ${hypr_width}px; border-radius: ${wind_border}px;} element {border-radius: ${elem_border}px;}"
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
i_override="$(gsettings get org.gnome.desktop.interface icon-theme | sed "s/'//g")"
i_override="configuration {icon-theme: \"${i_override}\";}"

#// Launch rofi

rofi -show "${r_mode}" -theme-str "${r_scale}" -theme-str "${r_override}" -theme-str "${i_override}" -config "${roconf}"
