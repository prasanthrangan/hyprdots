#!/usr/bin/env sh

# set variables

scrDir=`dirname "$(realpath "$0")"`
source $scrDir/globalcontrol.sh
dstDir="${confDir}/dunst"

# regen conf

export iconTheme="$({ grep -q "^[[:space:]]*\$ICON[-_]THEME\s*=" "${hydeThemeDir}/hypr.theme" && grep "^[[:space:]]*\$ICON[-_]THEME\s*=" "${hydeThemeDir}/hypr.theme" | cut -d '=' -f2 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' ;} || 
              grep 'gsettings set org.gnome.desktop.interface icon-theme' "${hydeThemeDir}/hypr.theme" | awk -F "'" '{print $(NF - 1)}')"

export hypr_border
envsubst < "${dstDir}/dunst.conf" > "${dstDir}/dunstrc"
envsubst < "${dstDir}/wallbash.conf" >> "${dstDir}/dunstrc"
killall dunst
dunst &
