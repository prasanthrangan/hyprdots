#!/usr/bin/env sh


#// set variables

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
[ -z "${hydeTheme}" ] && echo "ERROR: unable to detect theme" && exit 1
get_themes


#// define functions

Theme_Change()
{
    local x_switch=$1
    for i in ${!thmList[@]} ; do
        if [ "${thmList[i]}" == "${hydeTheme}" ] ; then
            if [ "${x_switch}" == 'n' ] ; then
                setIndex=$(( (i + 1) % ${#thmList[@]} ))
            elif [ "${x_switch}" == 'p' ] ; then
                setIndex=$(( i - 1 ))
            fi
            themeSet="${thmList[setIndex]}"
            break
        fi
    done
}

get_gtk_theme()
{
    local themeDir=$1
    echo "$({ grep -q "^[[:space:]]*\$GTK[-_]THEME\s*=" "${themeDir}/hypr.theme" && grep "^[[:space:]]*\$GTK[-_]THEME\s*=" "${themeDir}/hypr.theme" | cut -d '=' -f2 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' ;} || 
          grep 'gsettings set org.gnome.desktop.interface gtk-theme' "${themeDir}/hypr.theme" | awk -F "'" '{print $((NF - 1))}')"
}

get_icon_theme()
{
    local themeDir=$1
    echo "$({ grep -q "^[[:space:]]*\$ICON[-_]THEME\s*=" "${themeDir}/hypr.theme" && grep "^[[:space:]]*\$ICON[-_]THEME\s*=" "${themeDir}/hypr.theme" | cut -d '=' -f2 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' ;} ||  
          grep 'gsettings set org.gnome.desktop.interface icon-theme' "${themeDir}/hypr.theme" | awk -F "'" '{print $(NF - 1)}')"
}

join_array()
{
  local IFS="$1"
  shift
  echo "$*"
}

#// evaluate options

while getopts "nps:" option ; do
    case $option in

    n ) # set next theme
        Theme_Change n
        export xtrans="grow" ;;

    p ) # set previous theme
        Theme_Change p
        export xtrans="outer" ;;

    s ) # set selected theme
        themeSet="$OPTARG" ;;

    * ) # invalid option
        echo "... invalid option ..."
        echo "$(basename "${0}") -[option]"
        echo "n : set next theme"
        echo "p : set previous theme"
        echo "s : set input theme"
        exit 1 ;;
    esac
done


#// update control file

if ! $(echo "${thmList[@]}" | grep -wq "${themeSet}") ; then
    themeSet="${hydeTheme}"
fi

set_conf "hydeTheme" "${themeSet}"
echo ":: applying theme :: \"${themeSet}\""
export reload_flag=1
source "${scrDir}/globalcontrol.sh"


#// hypr
[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ] &&  hyprctl keyword misc:disable_autoreload 1 -q
sed '1d' "${hydeThemeDir}/hypr.theme" > "${confDir}/hypr/themes/theme.conf" # Useless and already handled by swwwallbash.sh but kept for robustness

gtkTheme=$(get_gtk_theme "$hydeThemeDir")
gtkIcon=$(get_icon_theme "$hydeThemeDir")

#// qtct

sed -i "/^icon_theme=/c\icon_theme=${gtkIcon}" "${confDir}/qt5ct/qt5ct.conf"
sed -i "/^icon_theme=/c\icon_theme=${gtkIcon}" "${confDir}/qt6ct/qt6ct.conf"
sed -i "/^Theme=/c\Theme=${gtkIcon}" "${confDir}/kdeglobals"

#// gtk3

sed -i "/^gtk-theme-name=/c\gtk-theme-name=${gtkTheme}" $confDir/gtk-3.0/settings.ini
sed -i "/^gtk-icon-theme-name=/c\gtk-icon-theme-name=${gtkIcon}" $confDir/gtk-3.0/settings.ini


#// gtk4

if [ -d /run/current-system/sw/share/themes ] ; then
    themeDir=/run/current-system/sw/share/themes
else
    themeDir=~/.themes
fi
rm -rf "${confDir}/gtk-4.0"
ln -s "${themeDir}/${gtkTheme}/gtk-4.0" "${confDir}/gtk-4.0"


#// flatpak GTK

if pkg_installed flatpak ; then
    if [ "${enableWallDcol}" -eq 0 ] ; then
        flatpak --user override --env=GTK_THEME="${gtkTheme}"
        flatpak --user override --env=ICON_THEME="${gtkIcon}"
    else
        flatpak --user override --env=GTK_THEME="Wallbash-Gtk"
        flatpak --user override --env=ICON_THEME="${gtkIcon}"
    fi
fi


#// dunst

unset iconThemes
while read thmDir ; do
    if [ "$(basename "${thmDir}")" == "${hydeTheme}" ] ; then
        continue
    fi
    iconThemes+=($(get_icon_theme "$thmDir"))
done < <(find "${hydeConfDir}/themes" -mindepth 1 -maxdepth 1 -type d)
echo "iconThemes1= ${iconThemes[@]}"
iconThemes=(${gtkIcon} "${iconThemes[*]}")
iconThemesConcat=$(join_array "," ${iconThemes[*]})

sed -i "/^    icon_theme =/c\    icon_theme = \"${iconThemesConcat}\"" "${confDir}/dunst/dunst.conf"


#// wallpaper

"${scrDir}/swwwallpaper.sh" -s "$(readlink "${hydeThemeDir}/wall.set")"

