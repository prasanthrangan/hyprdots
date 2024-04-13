#!/usr/bin/env sh


# set variables

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"


# regen conf

if pkg_installed spotify && pkg_installed spicetify-cli ; then

    if [ ! -w /opt/spotify ] || [ ! -w /opt/spotify/Apps ]; then
        notify-send -a "Hyprdots" "Permission needed for Wallbash Spotify theme"
        pkexec chmod a+wr /opt/spotify
        pkexec chmod a+wr /opt/spotify/Apps -R
    fi

    if [ "$(spicetify config | awk '{if ($1=="color_scheme") print $2}')" != "Wallbash" ] || [[ "${*}" == *"--reset"*  ]] ; then
        spicetify &> /dev/null
        mkdir -p ~/.config/spotify
        touch ~/.config/spotify/prefs
        sptfyConf=$(spicetify -c)
        spotfy_flags='--ozone-platform=wayland'
        sed -i -e "/^prefs_path/ s+=.*$+= $HOME/.config/spotify/prefs+g" \
            -e "/^spotify_launch_flags/ s+=.*$+= $spotfy_flags+g" "$sptfyConf"
	    curl -L -o ${cacheDir}/landing/Spotify_Sleek.tar.gz https://github.com/prasanthrangan/hyprdots/raw/main/Source/arcs/Spotify_Sleek.tar.gz
        tar -xzf ${cacheDir}/landing/Spotify_Sleek.tar.gz -C ~/.config/spicetify/Themes/
        spicetify backup apply
        spicetify config current_theme Sleek
        spicetify config color_scheme Wallbash
        spicetify apply
    fi

    if pgrep -x spotify > /dev/null ; then
        pkill -x spicetify
        spicetify -q watch -s &
    fi

fi

