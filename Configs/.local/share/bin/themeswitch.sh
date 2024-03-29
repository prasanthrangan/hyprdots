#!/usr/bin/env sh


#// set variables

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
readarray -t theme_ctl < <( cut -d '|' -f 2 "${themeCtl}" )


#// define functions

Theme_Change()
{
    local x_switch=$1
    local curTheme=$(awk -F '|' '$1 == 1 {print $2}' "${themeCtl}")
    for (( i=0 ; i<${#theme_ctl[@]} ; i++ ))
    do
        if [ "${theme_ctl[i]}" == "${curTheme}" ] ; then
            if [ "${x_switch}" == 'n' ] ; then
                nextIndex=$(( (i + 1) % ${#theme_ctl[@]} ))
            elif [ "${x_switch}" == 'p' ] ; then
                nextIndex=$(( i - 1 ))
            fi
            themeSet="${theme_ctl[nextIndex]}"
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
        echo "n : set next theme"
        echo "p : set previous theme"
        echo "s : set theme from parameter"
        exit 1 ;;
    esac
done


#// update theme control

if [ `cat "${themeCtl}" | awk -F '|' -v thm=""${themeSet}"" '{if($2==thm) print$2}' | wc -w` -ne 1 ] ; then
    echo "ERROR: Unknown theme selected: ${themeSet}"
    echo "Available themes are:"
    cat "${themeCtl}" | cut -d '|' -f 2
    exit 1
else
    echo ":: ${themeSet} ::"
    sed -i "s/^1/0/g" "${themeCtl}"
    awk -F '|' -v thm="${themeSet}" '{OFS=FS} {if($2==thm) $1=1; print$0}' "${themeCtl}" > "${scrDir}/tmp" && mv "${scrDir}/tmp" "${themeCtl}"
fi


#// hyprland

cp "${wallbashDir}/${themeSet}/hypr.conf" "${confDir}/hypr/themes/theme.conf"
hyprctl reload
source "${scrDir}/globalcontrol.sh"


#// code

if [ ! -z "$(grep '^1|' "$themeCtl" | awk -F '|' '{print $3}')" ] ; then
    codex=$(grep '^1|' "$themeCtl" | awk -F '|' '{print $3}' | cut -d '~' -f 1)
    if [ $(code --list-extensions | grep -iwc "${codex}") -eq 0 ] ; then
        code --install-extension "${codex}" 2> /dev/null
    fi
    codet=$(grep '^1|' "$themeCtl" | awk -F '|' '{print $3}' | cut -d '~' -f 2)
    jq --arg codet "${codet}" '.["workbench.colorTheme"] |= $codet' "$confDir/Code/User/settings.json" > tmpvsc && mv tmpvsc "$confDir/Code/User/settings.json"
fi


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

getWall=`grep '^1|' "$themeCtl" | awk -F '|' '{print $NF}'`
getWall=`eval echo "$getWall"`
"${scrDir}/swwwallpaper.sh" -s "${getWall}"

