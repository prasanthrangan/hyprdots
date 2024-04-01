#!/usr/bin/env sh


#// config vars

enableWallDcol=0
hydeTheme="Catppuccin-Mocha"
confDir="${XDG_CONFIG_HOME:-$HOME/.config}"
hydeThemeDir="${confDir}/hyde/themes/${hydeTheme}"
wallbashDir="${confDir}/hyde/wallbash"


#// cache vars

cacheDir="$HOME/.cache/hyde"
thmbDir="${cacheDir}/thumbs"
dcolDir="${cacheDir}/dcols"
hashMech="sha1sum"


#// extra vars

gtkTheme="$(grep 'gsettings set org.gnome.desktop.interface gtk-theme' ${hydeThemeDir}/hypr.theme | awk -F "'" '{print $((NF - 1))}')"
gtkIcon="$(grep 'gsettings set org.gnome.desktop.interface icon-theme' ${hydeThemeDir}/hypr.theme | awk -F "'" '{print $((NF - 1))}')"
gtkMode="$(grep 'gsettings set org.gnome.desktop.interface color-scheme' ${hydeThemeDir}/hypr.theme | awk -F "['-]" '{print $((NF - 1))}')"
hypr_border=`hyprctl -j getoption decoration:rounding | jq '.int'`
hypr_width=`hyprctl -j getoption general:border_size | jq '.int'`


#// pacman fns

pkg_installed()
{
    local pkgIn=$1

    if pacman -Qi $pkgIn &> /dev/null
    then
        return 0 # echo "${pkgIn} is already installed..."
    else
        return 1 # echo "${pkgIn} is not installed..."
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

    if [ -z "${hashMap}" ] ; then
        echo "ERROR: No image found in ${wallSource}"
        exit 0
    fi

    while read -r hash image ; do
        wallHash+=("${hash}")
        walList+=("${image}")
    done <<< "${hashMap}"

    if [ "${2}" == "--verbose" ] ; then
        echo "// Hash Map for \"${wallSource}\""
        for indx in "${!wallHash[@]}" ; do
            echo ":: \${wallHash[${indx}]}=\"${wallHash[indx]}\" :: \${walList[${indx}]}=\"${walList[indx]}\""
        done
    fi
}

get_themes()
{
    unset thmList
    unset thmWall

    while read thmDir ; do
        if [ ! -e "$(readlink "${thmDir}/wall.set")" ] ; then
            echo "fixig link :: ${thmDir}/wall.set"
            get_hashmap "${thmDir}"
            ln -fs "${walList[0]}" "${thmDir}/wall.set"
        fi
        thmList+=("$(basename ${thmDir})")
        thmWall+=("$(readlink "${thmDir}/wall.set")")
    done < <(find "${confDir}/hyde/themes" -mindepth 1 -maxdepth 1 -type d | sort)

    if [ "${1}" == "--verbose" ] ; then
        echo "// Theme Control //"
        for indx in "${!thmList[@]}" ; do
            echo -e ":: \${thmList[${indx}]}=\"${thmList[indx]}\" :: \${thmWall[${indx}]}=\"${thmWall[indx]}\""
        done
    fi
}

