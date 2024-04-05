#!/usr/bin/env sh


#// hyde envs

export confDir="${XDG_CONFIG_HOME:-$HOME/.config}"
export hydeConfDir="${confDir}/hyde"
export cacheDir="$HOME/.cache/hyde"
export thmbDir="${cacheDir}/thumbs"
export dcolDir="${cacheDir}/dcols"
export hashMech="sha1sum"

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
    unset thmSortS
    unset thmListS
    unset thmWallS
    unset thmSort
    unset thmList
    unset thmWall

    while read thmDir ; do
        if [ ! -e "$(readlink "${thmDir}/wall.set")" ] ; then
            echo "fixig link :: ${thmDir}/wall.set"
            get_hashmap "${thmDir}"
            ln -fs "${walList[0]}" "${thmDir}/wall.set"
        fi
        [ -f "${thmDir}/.sort" ] && thmSortS+=("$(head -1 "${thmDir}/.sort")") || thmSortS+=("0")
        thmListS+=("$(basename ${thmDir})")
        thmWallS+=("$(readlink "${thmDir}/wall.set")")
    done < <(find "${hydeConfDir}/themes" -mindepth 1 -maxdepth 1 -type d | sort)

    while read -r sort theme wall ; do
        thmSort+=("${sort}")
        thmList+=("${theme}")
        thmWall+=("${wall}")
    done < <(parallel --link -N1 echo "{}" ::: "${thmSortS[@]}" ::: "${thmListS[@]}" ::: "${thmWallS[@]}" | sort -n -k 1)

    if [ "${1}" == "--verbose" ] ; then
        echo "// Theme Control //"
        for indx in "${!thmList[@]}" ; do
            echo -e ":: \${thmSort[${indx}]}=\"${thmSort[indx]}\" :: \${thmList[${indx}]}=\"${thmList[indx]}\" :: \${thmWall[${indx}]}=\"${thmWall[indx]}\""
        done
    fi
}

[ -f "${hydeConfDir}/hyde.conf" ] && source "${hydeConfDir}/hyde.conf"

case "${enableWallDcol}" in
    0|1|2|3) ;;
    *) enableWallDcol=0 ;;
esac

if [ -z ${hydeTheme} ] || [ ! -d "${hydeConfDir}/themes/${hydeTheme}" ] ; then
    get_themes
    hydeTheme="${thmList[0]}"
fi

export hydeTheme
export hydeThemeDir="${hydeConfDir}/themes/${hydeTheme}"
export wallbashDir="${hydeConfDir}/wallbash"
export enableWallDcol


#// hypr vars

export hypr_border=$(hyprctl -j getoption decoration:rounding | jq '.int')
export hypr_width=$(hyprctl -j getoption general:border_size | jq '.int')


#// extra fns

pkg_installed()
{
    local pkgIn=$1

    if pacman -Qi ${pkgIn} &> /dev/null
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

set_conf()
{
    local varName="${1}"
    local varData="${2}"
    touch "${hydeConfDir}/hyde.conf"

    if [ $(grep -c "^${varName}=" "${hydeConfDir}/hyde.conf") -eq 1 ] ; then
        sed -i "/^${varName}=/c${varName}=\"${varData}\"" "${hydeConfDir}/hyde.conf"
    else
        echo "${varName}=\"${varData}\"" >> "${hydeConfDir}/hyde.conf"
    fi
}

