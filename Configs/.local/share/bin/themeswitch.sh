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
    echo "ERROR: theme not found, available themes are :: ${thmList[@]}"
    exit 1
fi

set_conf "hydeTheme" "${themeSet}"
echo ":: applying theme :: \"${themeSet}\""
export reload_flag=1
source "${scrDir}/globalcontrol.sh"


#// hypr

sed '1d' "${hydeThemeDir}/hypr.theme" > "${confDir}/hypr/themes/theme.conf"
export gtkIcon="$(grep 'gsettings set org.gnome.desktop.interface icon-theme' "${hydeThemeDir}/hypr.theme" | awk -F "'" '{print $((NF - 1))}')"


#// qtct

sed -i "/^icon_theme=/c\icon_theme=${gtkIcon}" "${confDir}/qt5ct/qt5ct.conf"
sed -i "/^icon_theme=/c\icon_theme=${gtkIcon}" "${confDir}/qt6ct/qt6ct.conf"


#// gtk3

sed -i "/^gtk-theme-name=/c\gtk-theme-name=${themeSet}" $confDir/gtk-3.0/settings.ini
sed -i "/^gtk-icon-theme-name=/c\gtk-icon-theme-name=${gtkIcon}" $confDir/gtk-3.0/settings.ini


#// gtk4

if [ -d /run/current-system/sw/share/themes ]; then
    themeDir=/run/current-system/sw/share/themes
else
    themeDir=/usr/share/themes
fi
rm -rf "${confDir}/gtk-4.0"
ln -s "${themeDir}/${themeSet}/gtk-4.0" "${confDir}/gtk-4.0"


#// flatpak GTK

flatpak --user override --env=GTK_THEME="${themeSet}"
flatpak --user override --env=ICON_THEME="${gtkIcon}"


#// wallpaper

"${scrDir}/swwwallpaper.sh" -s "$(readlink "${hydeThemeDir}/wall.set")"
