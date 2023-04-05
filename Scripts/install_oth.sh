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


# firefox
if pkg_installed firefox
then
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

