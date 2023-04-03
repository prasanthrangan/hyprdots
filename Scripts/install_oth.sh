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
if pkg_installed spotify
then
    echo "launching spotify..."
    /usr/bin/spotify &
    spoty_pid=$!
    sleep 5
    kill -9 $spoty_pid

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
    echo "launching firefox..."
    /usr/bin/firefox &
    ffox_pid=$!
    sleep 5
    kill -9 $ffox_pid

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

