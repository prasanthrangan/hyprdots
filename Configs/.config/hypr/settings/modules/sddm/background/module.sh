#!/bin/bash
_getHeader "$name" "$author"

if gum confirm "Do you want to update the SDDM background image with the current wallpaper?" ;then

    cache_file="$HOME/.cache/current_wallpaper"
    
    if [ ! -d /etc/sddm.conf.d/ ]; then
        sudo mkdir /etc/sddm.conf.d
        echo "Folder /etc/sddm.conf.d created."
    fi

    sudo cp ~/dotfiles/sddm/sddm.conf /etc/sddm.conf.d/
    echo "File /etc/sddm.conf.d/sddm.conf updated."

    current_wallpaper=$(cat "$cache_file")
    extension="${current_wallpaper##*.}"

    sudo cp $current_wallpaper /usr/share/sddm/themes/sugar-candy/Backgrounds/current_wallpaper.$extension
    echo "Current wallpaper copied into /usr/share/sddm/themes/sugar-candy/Backgrounds/"
    new_wall=$(echo $current_wallpaper | sed "s|$HOME/wallpaper/||g")
    sudo cp ~/dotfiles/sddm/theme.conf /usr/share/sddm/themes/sugar-candy/

    sudo sed -i 's/CURRENTWALLPAPER/'"current_wallpaper.$extension"'/' /usr/share/sddm/themes/sugar-candy/theme.conf

    echo ""
    echo "SDDM background successfully updated!"
    sleep 2
fi
_goBack
