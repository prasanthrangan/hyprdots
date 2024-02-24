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
    if [ ! -w /opt/spotify ] || [ ! -w /opt/spotify/Apps ]; then
        sudo chmod a+wr /opt/spotify
        sudo chmod a+wr /opt/spotify/Apps -R
    fi

    spicetify &> /dev/null
    mkdir -p ~/.config/spotify
    touch ~/.config/spotify/prefs
    sptfyConf=$(spicetify -c)
    sed -i "/^prefs_path/ s+=.*$+= $HOME/.config/spotify/prefs+g" "${sptfyConf}"
    tar -xzf ${CloneDir}/Source/arcs/Spotify_Sleek.tar.gz -C ~/.config/spicetify/Themes/
    spicetify backup apply
    spicetify config current_theme Sleek
    spicetify config color_scheme Wallbash
    spicetify apply
fi


# firefox
if pkg_installed firefox
    then
    FoxRel=$(find ~/.mozilla/firefox -maxdepth 1 -type d -name "*.default-release" | head -1)

    if [ -z "${FoxRel}" ] ; then
        firefox &> /dev/null &
        sleep 1
        FoxRel=$(find ~/.mozilla/firefox -maxdepth 1 -type d -name "*.default-release" | head -1)
    else
        BkpDir="${HOME}/.config/cfg_backups/$(date +'%y%m%d_%Hh%Mm%Ss')_apps"
        mkdir -p "${BkpDir}"
        cp -r ~/.mozilla/firefox "${BkpDir}"
    fi

    tar -xzf ${CloneDir}/Source/arcs/Firefox_UserConfig.tar.gz -C "${FoxRel}"
    tar -xzf ${CloneDir}/Source/arcs/Firefox_Extensions.tar.gz -C ~/.mozilla/

    find ~/.mozilla/extensions -maxdepth 1 -type f -name "*.xpi" | while read fext
    do
        firefox -profile "${FoxRel}" "${fext}" &> /dev/null &
    done
fi

