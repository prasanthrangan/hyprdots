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

if ! pkg_installed imagemagick
then
    echo "ERROR : imagemagick is not installed..."
    exit 0
fi

# set variables
ctlFile="$HOME/.config/swww/wall.ctl"
ThemeList="$(awk -F '|' '{print $2}' $ctlFile)"
SwwwPath="$HOME/.config/swww"
CacheDir="$HOME/.config/swww/.cache"
ForceOverwrite=false

# evaluate options
while getopts "f" option ; do
    case $option in
    f ) # set next wallpaper
        ForceOverwrite=true ;;
    * ) # invalid option
    	echo "f : force creation of new thumbnails (delete old cache)"
        exit 1 ;;
    esac
done

# create thumbnails for each theme > wallpapers
for theme in ${ThemeList}
do
    if [ $ForceOverwrite == true ]; then
       rm -Rf ${CacheDir}/${theme}
    fi

    if [ ! -d ${CacheDir}/${theme} ] ; then
        mkdir -p ${CacheDir}/${theme}
    fi

    # Map all wallpapers from the theme to an array with -print0, in case someone decided to use spaces
    mapfile -d '' wpArray < <(find ${SwwwPath}/${theme} -type f -print0)

    echo "Creating up to ${#wpArray[@]} thumbnails for ${theme}"

    for wpFullName in "${wpArray[@]}"
    do
        wpBaseName=$(basename "${wpFullName}")
        if [ ! -f "${CacheDir}/${theme}/${wpBaseName}" ] ; then
            convert "${wpFullName}" -thumbnail 500x500^ -gravity center -extent 500x500 "${CacheDir}/${theme}/${wpBaseName}"
        fi
    done

done
