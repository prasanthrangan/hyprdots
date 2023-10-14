#!/usr/bin/env bash
# source variables
ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh


# Trigger upgrade
if [ "$1" == "up" ] ; then
# Check if the process is running
if ! pgrep -f "kitty --start-as fullscreen --title systemupdate sh" > /dev/null
then
    echo "run"
    kitty --start-as fullscreen --title systemupdate sh -c "$HOME/.config/hypr/scripts/systemupdate.sh upgrade" > /dev/null
    #alacritty --title "System Updates" -e $HOME/.config/hypr/scripts/systemupdate.sh now
if ! pgrep waybar > /dev/null
then 
waybar > /dev/null 2> /dev/null &
exit 0
else
    exit 0
    fi 
else

notify-send -a " 󰮯  " "System Update" "  Process Ongoing"
exit 0
fi
fi

#khing#khing#khing#khing#khing#khingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhing
updateCheck () {
# Check release
if [ ! -f /etc/arch-release ] ; then
    exit 0
fi

# Check for updates
get_aurhlpr
aur=`${aurhlpr} -Qua | wc -l`
ofc=`checkupdates | wc -l`

# Check for flatpak updates
if pkg_installed flatpak ; then
    fpk=`flatpak remote-ls --updates | wc -l`
    fpk_disp="\n󰏓 Flatpak $fpk"
    fpk_exup="; flatpak update"
else
    fpk=0
    fpk_disp=""
fi

# Calculate total available updates
upd=$(( ofc + aur + fpk ))
}
#khing#khing#khing#khing#khing#khingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhing
updateOfc () {
if [ "$ofc" -ne 0 ]; then
kitten icat --align left $(find $HOME/.config/neofetch/gifs/ -name "*.gif" | sort -R | head -1)
read -p "$ofc Official packages available, UPDATE? (Y/n) [Y]: " answer
answer=${answer:-Y} # use 'Y' as default value if no input is provided
# Convert the answer to uppercase
answer=${answer^^}
if [ "$answer" == "Y" ]; then
echo "AUR Wrapper: $aurhlpr"
$aurhlpr -Syu 
#echo "Official $ofc"
#sudo pacman -Syu

else 
echo "
|---------------------------------------------------------------------------------|
|                            No changes for Official Packages                     |
|---------------------------------------------------------------------------------|






"
fi
fi
}
#khing#khing#khing#khing#khing#khingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhing
updateAUR () {
if [ "$aur" -ne 0 ]; then
kitten icat --align left $(find $HOME/.config/neofetch/gifs/ -name "*.gif" | sort -R | head -1)
read -p "$aur AUR packages available, UPDATE? (Y/n) [Y]: " answer
answer=${answer:-Y} # use 'Y' as default value if no input is provided
# Convert the answer to uppercase
answer=${answer^^}
if [ "$answer" == "Y" ]; then
        echo "AUR Wrapper: $aurhlpr"
    $aurhlpr -Syu 
else 
echo "
|---------------------------------------------------------------------------------|
|                            No changes for AUR Packages                          |
|---------------------------------------------------------------------------------|






"
fi
fi
}
#khing#khing#khing#khing#khing#khingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhing
updateFpk () {
if pkg_installed flatpak ; then

if [ "$fpk" -ne 0 ]; then
kitten icat --align left $(find $HOME/.config/neofetch/gifs/ -name "*.gif" | sort -R | head -1)
# Ask for confirmation
read -p "$fpk Flatpak packages available, UPDATE? (Y/n) [Y]: " answer
answer=${answer:-Y} # use 'Y' as default value if no input is provided
# Convert the answer to uppercase
answer=${answer^^}
if [ "$answer" == "Y" ]; then
flatpak update
else 
echo "
|---------------------------------------------------------------------------------|
|                            No changes for Flatpak Packages                      |
|---------------------------------------------------------------------------------|






"
fi
fi
fi
}
#khing#khing#khing#khing#khing#khingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhing




if [ "$1" == "upgrade" ] ; then
neofetch 
echo "
|---------------------------------------------------------------------------------|         
                                                                            __ 
 _____            _                  _____         _       _               |  |
|   __| _ _  ___ | |_  ___  _____   |  |  | ___  _| | ___ | |_  ___  ___   |  |
|__   || | ||_ -||  _|| -_||     |  |  |  || . || . || .'||  _|| -_||_ -|  |__|
|_____||_  ||___||_|  |___||_|_|_|  |_____||  _||___||__,||_|  |___||___|  |__|
       |___|                               |_|                                 


|---------------------------------------------------------------------------------|
 
"
updateCheck #Recheck Updates
updateOfc   #Official
updateAUR   #AUR
updateFpk   #Flatpak
echo "




|----------------------------------------------------------------------------------------|
                                                                                 __ 
 _____            _                              _             _       _        |  |
|   __| _ _  ___ | |_  ___  _____    _ _  ___   | |_  ___    _| | ___ | |_  ___ |  |
|__   || | ||_ -||  _|| -_||     |  | | || . |  |  _|| . |  | . || .'||  _|| -_||__|
|_____||_  ||___||_|  |___||_|_|_|  |___||  _|  |_|  |___|  |___||__,||_|  |___||__|
       |___|                             |_|                                        

|----------------------------------------------------------------------------------------|
 
                                    
" 
kitten icat --align left $(find $HOME/.config/neofetch/gifs/ -name "*.gif" | sort -R | head -1)

echo "Please review packages!
" 
#updateCheck

# Ask for confirmation
read -p "Press ENTER to Continue "
exit 0

fi
#khing#khing#khing#khing#khing#khingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhingkhing

updateCheck
# Show tooltip
if [ $upd -eq 0 ] ; then
    # upd="" #Remove Icon completely
     upd="󰮯"   #If zero Display Icon only
 #   notify-send -a " 󰮯  " "System Update" "  Packages are up to date"
    echo "{\"text\":\"$upd\", \"tooltip\":\" Packages are up to date\"}"
else
    notify-send -a " 󰮯  " "System Update" "󱓽 Official $ofc\n󱓾 AUR $aur$fpk_disp"
    echo "{\"text\":\"󰮯 $upd\", \"tooltip\":\"󱓽 Official $ofc\n󱓾 AUR $aur$fpk_disp\"}"
fi
