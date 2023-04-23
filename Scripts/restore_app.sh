#!/bin/bash
#|---/ /+-----------------------------+---/ /|#
#|--/ /-| Script to configure my apps |--/ /-|#
#|-/ /--| Prasanth Rangan             |-/ /--|#
#|/ /---+-----------------------------+/ /---|#

source global_fn.sh

# steam
if pkg_installed steam
    then
    if [ ! -d ~/.local/share/Steam/Skins/ ]
        then
        mkdir -p ~/.local/share/Steam/Skins/
    fi
    tar -xzf ${CloneDir}/Source/arcs/Steam_Metro.tar.gz -C ~/.local/share/Steam/Skins/
fi

# spotify
if pkg_installed spotify && pkg_installed spicetify-cli
    then
    spotify &
    sleep 2
    killall spotify

    sudo chmod a+wr /opt/spotify
    sudo chmod a+wr /opt/spotify/Apps -R
    tar -xzf ${CloneDir}/Source/arcs/Spotify_Sleek.tar.gz -C ~/.config/spicetify/Themes/

    if [ $(ls -l ~/.config/spicetify/Backup | wc -l) -eq 0 ]
        then
        spicetify backup apply
    fi

    spicetify config current_theme Sleek
    spicetify config color_scheme Cherry
    spicetify apply
fi

# firefox
if pkg_installed firefox
    then
    firefox &
    sleep 3
    killall firefox

    FoxRel=`ls -l ~/.mozilla/firefox/ | grep .default-release | awk '{print $NF}'`
    if [ `echo $FoxRel | wc -w` -eq 1 ]
        then
        tar -xzf ${CloneDir}/Source/arcs/Firefox_UserConfig.tar.gz -C ~/.mozilla/firefox/${FoxRel}/
    else
        echo "ERROR: Please cleanup Firefox default-release directories"
    fi
fi

