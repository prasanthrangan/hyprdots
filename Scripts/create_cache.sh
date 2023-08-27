#!/usr/bin/env sh

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
    	echo "f : force creation of thumbnails (ignore existing)"
        exit 1 ;;
    esac
done

# create thumbnails for each theme > wallpapers
for theme in ${ThemeList}
do
    if [ ! -d ${CacheDir}/${theme} ] ; then
        mkdir -p ${CacheDir}/${theme}
    fi

    # Map all wallpapers from the theme to an array with -print0, in case someone decided to use spaces
    mapfile -d '' wpArray < <(find ${SwwwPath}/${theme} -type f -print0)

    echo "Creating up to ${#wpArray[@]} thumbnails for ${theme}"
   
    for wpFullName in "${wpArray[@]}"
    do
	wpBaseName=$(basename "${wpFullName}")
	if [ ! -f "${CacheDir}/${theme}/${wpBaseName}" ] || [ $ForceOverwrite == true ] ; then
	   convert "${wpFullName}" -thumbnail 500x500^ -gravity center -extent 500x500 "${CacheDir}/${theme}/${wpBaseName}"
        fi
    done

done
