#!/bin/bash
#|---/ /+-----------------------------+---/ /|#
#|--/ /-| Script to configure my apps |--/ /-|#
#|-/ /--| Prasanth Rangan             |-/ /--|#
#|/ /---+-----------------------------+/ /---|#

source global_fn.sh


# rofi
if pkg_installed rofi
then
    sudo cp ~/Dots/Configs/.config/rofi/cat_*.rasi /usr/share/rofi/themes/
    if [ `find /usr/share/applications -name "rofi*.desktop"` | wc -l -gt 0 ]
        then
        sudo rm /usr/share/applications/rofi*.desktop
    fi
fi


# steam
if pkg_installed steam
then
    if [ ! -d ~/.local/share/Steam/Skins/ ]
    then
        mkdir -p ~/.local/share/Steam/Skins/
    fi
    tar -xvzf ~/Dots/Source/arcs/Steam_Metro.tar.gz -C ~/.local/share/Steam/Skins/
fi


# spotify
if pkg_installed spotify && pkg_installed spicetify-cli
then
    spotify &
    sleep 5
    killall spotify

    sudo chmod a+wr /opt/spotify
    sudo chmod a+wr /opt/spotify/Apps -R

    if [ $(ls -A ~/.config/spicetify/Backup | wc -l) -eq 0 ]
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
    sleep 5
    killall firefox

    if [ -d ~/.mozilla/firefox/*.default-release ]
    then
        FoxRel=`ls -l ~/.mozilla/firefox/ | grep .default-release | awk '{print $NF}'`

        if [ ! -d ~/.mozilla/firefox/${FoxRel}/chrome ]
        then
            mkdir ~/.mozilla/firefox/${FoxRel}/chrome
        fi
        cp ~/Dots/Source/t2_firefox.css ~/.mozilla/firefox/${FoxRel}/chrome/userChrome.css
        echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' > ~/.mozilla/firefox/${FoxRel}/user.js
        echo 'user_pref("browser.tabs.tabmanager.enabled", false);' >> ~/.mozilla/firefox/${FoxRel}/user.js
    fi
fi

