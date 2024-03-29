#!/usr/bin/env sh


#// wallpaper vars

enableWallDcol=0
confDir="${XDG_CONFIG_HOME:-$HOME/.config}"
cacheDir="$HOME/.cache/hyprdots"
themeCtl="${confDir}/hyprdots/theme.ctl"
wallDir="${confDir}/swww"
thmbDir="${cacheDir}/thumbs"
dcolDir="${cacheDir}/dcols"
wallbashDir="${confDir}/hyprdots/wallbash"
hashMech="sha1sum"


#// theme vars

gtkTheme=`gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g"`
gtkIcon=`gsettings get org.gnome.desktop.interface icon-theme | sed "s/'//g"`
gtkMode=`gsettings get org.gnome.desktop.interface color-scheme | sed "s/'//g" | awk -F '-' '{print $2}'`


#// hypr vars

hypr_border=`hyprctl -j getoption decoration:rounding | jq '.int'`
hypr_width=`hyprctl -j getoption general:border_size | jq '.int'`


#// pacman fns

pkg_installed()
{
    local pkgIn=$1

    if pacman -Qi $pkgIn &> /dev/null
    then
        #echo "${pkgIn} is already installed..."
        return 0
    else
        #echo "${pkgIn} is not installed..."
        return 1
    fi
}

get_aurhlpr()
{
    if pkg_installed yay
    then
        aurhlpr="yay"
    elif pkg_installed paru
    then
        aurhlpr="paru"
    fi
}


#// wallpaper fns

get_hashmap()
{
    local wallSource="${1}"
    unset wallHash
    unset walList
    hashMap=$(find "${wallSource}" -type f \( -iname "*.gif" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -exec "${hashMech}" {} + | sort -k2)

    while read -r hash image ; do
        wallHash+=("${hash}")
        walList+=("${image}")
    done <<< "${hashMap}"

    if [ "${2}" == "--verbose" ] ; then
        echo ":: source :: \"${wallSource}\""
        for indx in "${!wallHash[@]}" ; do
            echo ":: ${indx} :: \"${wallHash[indx]}\" :: \"${walList[indx]}\""
        done
    fi
}

get_hashmap_x2()
{
    local wallSource="${1}"
    unset wallHash
    unset walList
    hashMap=$(find "${wallSource}" -type f \( -iname "*.gif" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -exec "${hashMech}" {} + | sort -k2)

    while read -r hash image ; do
        imgh="$(echo ${image} | "${hashMech}" | awk '{print $1}')"
        wallHash+=("${hash}${imgh}")
        walList+=("${image}")
    done <<< "${hashMap}"

    if [ "${2}" == "--verbose" ] ; then
        echo ":: source :: \"${wallSource}\""
        for indx in "${!wallHash[@]}" ; do
            echo ":: ${indx} :: \"${wallHash[indx]}\" :: \"${walList[indx]}\""
        done
    fi
}

