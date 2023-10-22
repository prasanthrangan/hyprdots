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
SwwwPath="$HOME/.config/swww"
export CacheDir="$HOME/.config/swww/.cache"
ThemeList="$(awk -F '|' '{print $2}' $ctlFile)"

# evaluate options
while getopts "f" option ; do
    case $option in
    f ) # force remove cache
        rm -Rf ${CacheDir}
        echo "Cache dir ${CacheDir} cleared...";;
    * ) # invalid option
    	echo "f : force create thumbnails (delete old cache)"
        exit 1 ;;
    esac
done

imagick_t2 () {
    wpFullName="$1"
    theme=`dirname "${wpFullName}" | awk -F '/' '{print $NF}'`
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

export -f imagick_t2

# create thumbnails for each theme > wallpapers
for theme in ${ThemeList}
do
    mkdir -p ${CacheDir}/${theme}

    # Map all wallpapers from the theme to an array with -print0, in case someone decided to use spaces
    mapfile -d '' wpArray < <(find ${SwwwPath}/${theme} -type f -print0)
    echo "Creating thumbnails for ${theme} [${#wpArray[@]}]"
    parallel --bar imagick_t2 ::: "${wpArray[@]}"
done

