#!/usr/bin/env sh


# set variables
ScrDir=`dirname "$(realpath "$0")"`
source "${ScrDir}/globalcontrol.sh"
readarray -t theme_ctl < <( cut -d '|' -f 2 $ThemeCtl )


# define functions
Theme_Change()
{
    local x_switch=$1
    local curTheme=$(awk -F '|' '$1 == 1 {print $2}' $ThemeCtl)
    for (( i=0 ; i<${#theme_ctl[@]} ; i++ ))
    do
        if [ "${theme_ctl[i]}" == "${curTheme}" ] ; then
            if [ $x_switch == 'n' ] ; then
                nextIndex=$(( (i + 1) % ${#theme_ctl[@]} ))
            elif [ $x_switch == 'p' ] ; then
                nextIndex=$(( i - 1 ))
            fi
            ThemeSet="${theme_ctl[nextIndex]}"
            break
        fi
    done
}


# evaluate options
while getopts "nps:t" option ; do
    case $option in

    n ) # set next theme
        Theme_Change n
        export xtrans="grow" ;;

    p ) # set previous theme
        Theme_Change p
        export xtrans="outer" ;;

    s ) # set selected theme
        ThemeSet="$OPTARG" ;;

    t ) # display tooltip
        echo ""
        echo "󰆊 Next/Previous Theme"
        exit 0 ;;

    * ) # invalid option
        echo "n : set next theme"
        echo "p : set previous theme"
        echo "s : set theme from parameter"
        echo "t : display tooltip"
        exit 1 ;;
    esac
done


# update theme control
if [ `cat "$ThemeCtl" | awk -F '|' -v thm=$ThemeSet '{if($2==thm) print$2}' | wc -w` -ne 1 ] ; then
    echo "Unknown theme selected: $ThemeSet"
    echo "Available themes are:"
    cat "$ThemeCtl" | cut -d '|' -f 2
    exit 1
else
    echo "Selected theme: $ThemeSet"
    sed -i "s/^1/0/g" "$ThemeCtl"
    awk -F '|' -v thm=$ThemeSet '{OFS=FS} {if($2==thm) $1=1; print$0}' "$ThemeCtl" > "${ScrDir}/tmp" && mv "${ScrDir}/tmp" "$ThemeCtl"
fi


# hyprland
ln -fs $ConfDir/hypr/themes/${ThemeSet}.conf $ConfDir/hypr/themes/theme.conf
hyprctl reload
source "${ScrDir}/globalcontrol.sh"


# code
if [ ! -z "$(grep '^1|' "$ThemeCtl" | awk -F '|' '{print $3}')" ] ; then
    codex=$(grep '^1|' "$ThemeCtl" | awk -F '|' '{print $3}' | cut -d '~' -f 1)
    if [ $(code --list-extensions |  grep -iwc "${codex}") -eq 0 ] ; then
        code --install-extension "${codex}" 2> /dev/null
    fi
    codet=$(grep '^1|' "$ThemeCtl" | awk -F '|' '{print $3}' | cut -d '~' -f 2)
    jq --arg codet "${codet}" '.["workbench.colorTheme"] |= $codet' "$ConfDir/Code/User/settings.json" > tmpvsc && mv tmpvsc "$ConfDir/Code/User/settings.json"
fi


# gtk3
sed -i "/^gtk-theme-name=/c\gtk-theme-name=${ThemeSet}" $ConfDir/gtk-3.0/settings.ini
sed -i "/^gtk-icon-theme-name=/c\gtk-icon-theme-name=${gtkIcon}" $ConfDir/gtk-3.0/settings.ini


# gtk4
[ -L "$ConfDir/gtk-4.0" ] && rm "$ConfDir/gtk-4.0" || rm -rf "$ConfDir/gtk-4.0"
ln -s /usr/share/themes/$ThemeSet/gtk-4.0 $ConfDir/gtk-4.0


# flatpak GTK
flatpak --user override --env=GTK_THEME="${ThemeSet}"
flatpak --user override --env=ICON_THEME="${gtkIcon}"


# wallpaper
getWall=`grep '^1|' "$ThemeCtl" | awk -F '|' '{print $NF}'`
getWall=`eval echo "$getWall"`
"${ScrDir}/swwwallpaper.sh" -s "${getWall}"

