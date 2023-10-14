#!/usr/bin/env bash


# source variables
ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh


########################3#########################################################################################3
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
   # fpk_exup="; flatpak update"
else
    fpk=0
    fpk_disp=""
fi
# Calculate total available updates
upd=$(( ofc + aur + fpk ))
echo $upd
}
########################3#########################################################################################3
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
########################3#########################################################################################3
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
########################3#########################################################################################3
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
########################3#########################################################################################3
	# Trigger upgrade
if [ "$1" == "up" ] ; then
if ! pgrep -f "kitty --start-as fullscreen --title systemupdate sh" > /dev/null
then
#kitty --start-as fullscreen --title systemupdate sh -c '$HOME/.config/hypr/scripts/systemupdate.sh upgrade'
notify-send "run here"
#alacritty --title "System Updates" -e $HOME/.config/hypr/scripts/systemupdate.sh now
exit 0
else 
notify-send -a " 󰮯  " "System Update" "  Ongoing"
fi
fi


if [ "$1" == "upgrade" ] ; then

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
updateCheck #Recheck
updateOfc   #Officil
updateAUR
updateFpk
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
# Ask for confirmation
read -p "Press ENTER to Continue "
exit 0

fi



# Show tooltip
updateCheck
if [ $upd -eq 0 ] ; then
     upd=""     
  notify-send -a " 󰮯  " "System Update" "  Packages are up to date"
    echo "{\"text\":\"$upd\", \"tooltip\":\" Packages are up to date\"}"
else
    notify-send -a " 󰮯  " "System Update" "󱓽 Official $ofc\n󱓾 AUR $aur$fpk_disp"
    echo "{\"text\":\"󰮯 $upd\", \"tooltip\":\"󱓽 Official $ofc\n󱓾 AUR $aur$fpk_disp\"}"
fi

fi
