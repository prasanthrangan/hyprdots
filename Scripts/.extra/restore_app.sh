#!/bin/bash
#|---/ /+-----------------------------+---/ /|#
#|--/ /-| Script to configure my apps |--/ /-|#
#|-/ /--| Prasanth Rangan             |-/ /--|#
#|/ /---+-----------------------------+/ /---|#

ScrDir=`dirname "$(dirname "$(realpath "$0")")"`

source $ScrDir/global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname "$(realpath "$0")")..."
    exit 1
fi

CloneDir=`dirname "$(realpath $CloneDir)"`


# icons
if [ -f /usr/share/applications/rofi-theme-selector.desktop ] && [ -f /usr/share/applications/rofi.desktop ]
    then
    sudo rm /usr/share/applications/rofi-theme-selector.desktop
    sudo rm /usr/share/applications/rofi.desktop
fi
sudo sed -i "/^Icon=/c\Icon=adjust-colors" /usr/share/applications/nwg-look.desktop
sudo sed -i "/^Icon=/c\Icon=spectacle" /usr/share/applications/swappy.desktop


# steam
#if pkg_installed steam
#    then
#    skinsDir="${XDG_DATA_HOME:-$HOME/.local/share}/Steam/Skins/"
#    if [ ! -d "$skinsDir" ]
#        then
#        mkdir -p "$skinsDir"
#    fi
#    tar -xzf ${CloneDir}/Source/arcs/Steam_Metro.tar.gz -C "$skinsDir"
#fi


# spotify
if pkg_installed spotify && pkg_installed spicetify-cli
    then
    spotify &> /dev/null &
    sleep 2
    killall spotify

    sudo chmod a+wr /opt/spotify
    sudo chmod a+wr /opt/spotify/Apps -R
    tar -xzf ${CloneDir}/Source/arcs/Spotify_Sleek.tar.gz -C ~/.config/spicetify/Themes/

    if [ `ls -A ~/.config/spicetify/Backup | wc -l` -eq 0 ]
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
    firefox &> /dev/null &
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

