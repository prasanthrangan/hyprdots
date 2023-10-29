#!/bin/bash
#|---/ /+------------------------------------+---/ /|#
#|--/ /-| Script to generate wallpaper cache |--/ /-|#
#|-/ /--| Kemipso                            |-/ /--|#
#|/ /---+------------------------------------+/ /---|#

source global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname $(realpath $0))..."
    exit 1
fi

if ! pkg_installed imagemagick || ! pkg_installed parallel 
then
    echo "ERROR : dependency failed, imagemagick/parallel is not installed..."
    exit 0
fi

# set variables
ctlFile="$HOME/.config/swww/wall.ctl"
ctlLine=`grep '^1|' $ctlFile`
export CacheDir="$HOME/.config/swww/.cache"

# evaluate options
while getopts "fc" option ; do
    case $option in
    f ) # force remove cache
        rm -Rf ${CacheDir}
        echo "Cache dir ${CacheDir} cleared...";;
    c ) # use custom wallpaper
        shift $((OPTIND -1))
        inWall="$1"
        if [[ "${inWall}" == '~'* ]]; then
            inWall="$HOME${inWall:1}"
        fi
        if [[ -f "${inWall}" ]] ; then
            if [ `echo "$ctlLine" | wc -l` -eq "1" ] ; then
                curTheme=$(echo "$ctlLine" | cut -d '|' -f 2)
                sed -i "/^1|/c\1|${curTheme}|${inWall}" "$ctlFile"
            else
                echo "ERROR : $ctlFile Unable to fetch theme..."
                exit 1
            fi
        else
            echo "ERROR: wallpaper $1 not found..."
            exit 1
        fi ;;
    * ) # invalid option
        echo "...valid options are..."   
    	echo "./create_cache.sh -f                      # force create thumbnails (delete old cache)"
        echo "./create_cache.sh -c /path/to/wallpaper   # generate cache for custom walls"
        exit 1 ;;
    esac
done

# magick function
imagick_t2 () {
    theme="$1"
    wpFullName="$2"
    wpBaseName=$(basename "${wpFullName}")

    if [ ! -f "${CacheDir}/${theme}/${wpBaseName}" ]; then
        convert "${wpFullName}" -thumbnail 500x500^ -gravity center -extent 500x500 "${CacheDir}/${theme}/${wpBaseName}"
    fi

    if [ ! -f "${CacheDir}/${theme}/${wpBaseName}.rofi" ]; then
        convert -strip -resize 2000 -gravity center -extent 2000 -quality 90 "${wpFullName}" "${CacheDir}/${theme}/${wpBaseName}.rofi"
    fi

    if [ ! -f "${CacheDir}/${theme}/${wpBaseName}.blur" ]; then
        convert -strip -scale 10% -blur 0x3 -resize 100% "${wpFullName}" "${CacheDir}/${theme}/${wpBaseName}.blur"
    fi

    if [ ! -f "${CacheDir}/${theme}/${wpBaseName}.dcol" ]; then
        magick "${wpFullName}" -colors 4 -define histogram:unique-colors=true -format "%c" histogram:info: > "${CacheDir}/${theme}/${wpBaseName}.dcol"
    fi
}

# create thumbnails for each theme > wallpapers
export -f imagick_t2
while read ctlLine
do
    theme=$(echo $ctlLine | cut -d '|' -f 2)
    fullPath=$(echo "$ctlLine" | cut -d '|' -f 3 | sed "s+~+$HOME+")
    wallPath=$(dirname "$fullPath")
    mkdir -p ${CacheDir}/${theme}
    mapfile -d '' wpArray < <(find "${wallPath}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 | sort -z)
    echo "Creating thumbnails for ${theme} [${#wpArray[@]}]"
    parallel --bar imagick_t2 ::: "${theme}" ::: "${wpArray[@]}"
done < $ctlFile

