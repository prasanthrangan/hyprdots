#!/usr/bin/env bash 
#I'm too lazy

# Check release
if [ ! -f /etc/arch-release ] ; then
    exit 0
fi
# source variables
ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
get_aurhlpr
#process=$(pgrep -f  'bash /home/khing/.config/hypr/scripts/systemupdate.sh check' | wc -l)

# Define color variables
R='\033[0;31m' 
G='\033[0;32m'  
B='\033[0;34m' 
NC='\033[0m' # No Color

updateCheck () {

# Check for updates
aur=$(${aurhlpr} -Qua | wc -l)
ofc=$(checkupdates | wc -l)

# Check for flatpak updates
if pkg_installed flatpak ; then
    fpk=$(flatpak remote-ls --updates | wc -l)
    fpk_disp="\n󰏓 Flatpak $fpk"
    fpk_exup="; flatpak update"
else
    fpk=0
    fpk_disp=""
fi

# Calculate total available updates
upd=$(( ofc + aur + fpk ))
}

# Trigger upgrade and Avoiding Duplicate process, Also Overrides any systemCheck/systemupdate process
if [ "$1" == "up" ] ; then
# Check if the process is running
            if ! pgrep -f "kitty --start-as fullscreen --title systemupdate sh" > /dev/null
            then
                exec kitty --start-as fullscreen --title systemupdate sh -c "sh $HOME/.config/hypr/scripts/systemupdate.sh upgrade" > /dev/null
                #alacritty --title "System Updates" -e $HOME/.config/hypr/scripts/systemupdate.sh now

            fi
fi

updateExit () {
clear

cat << EOF


--------------------------------------------------------------------------------------------------
                                                                               __ 
 _____         _                _____        _____        ____      _         |  |
|   __|_ _ ___| |_ ___ _____   |  |  |___   |_   _|___   |    \ ___| |_ ___   |  |
|__   | | |_ -|  _| -_|     |  |  |  | . |    | | | . |  |  |  | .'|  _| -_|  |__|
|_____|_  |___|_| |___|_|_|_|  |_____|  _|    |_| |___|  |____/|__,|_| |___|  |__|
      |___|                          |_|                                          
                                            
--------------------------------------------------------------------------------------------------

EOF


}


updatePackages () {
    updateCheck

    if [ "$upd" -ne 0 ]; then
        kitten icat --align left "$(find "$HOME"/.config/neofetch/gifs/ -name "*.gif" | sort -R | head -1)"
        read -rp "==========>   [  $ofc  ] Official, [  $aur  ] AUR and [  $fpk  ] Flatpak packages available, UPDATE? (Y/n) [Y]: " answer
        answer=${answer:-Y} # use 'Y' as default value if no input is provided
        # Convert the answer to uppercase
        answer=${answer^^}
        if [ "$answer" == "Y" ]; then
            # echo -e "
            # # Updating \033[0;31mOfficial\033[0m, \033[0;31mAUR\033[0m and \033[0;31mFlatpak\033[0m packages.
            #         "
            $aurhlpr -Syu
            [ "$fpk" -ne 0 ] && flatpak update

echo -e "Please review packages! & Press \033[0;34mENTER\033[0m to \033[0;31mExit\033[0m"
        else
            cat << EOF


            #---------------------------------------------------------------------------------#
            #                            No changes for Official, AUR and Flatpak Packages    #
            #---------------------------------------------------------------------------------#

EOF
        fi
kitten icat --align left "$(find "$HOME"/.config/neofetch/gifs/ -name "*.gif" | sort -R | head -1)"
read -n 1 -s -t 3

    fi

}


if [ "$1" == "upgrade" ] ; then
neofetch 
cat << EOF

--------------------------------------------------------------------------------------------------
                                                          __ 
 _____         _                _____       _     _      |  |
|   __|_ _ ___| |_ ___ _____   |  |  |___ _| |___| |_ ___|  |
|__   | | |_ -|  _| -_|     |  |  |  | . | . | .'|  _| -_|__|
|_____|_  |___|_| |___|_|_|_|  |_____|  _|___|__,|_| |___|__|
      |___|                          |_|                     

--------------------------------------------------------------------------------------------------
                                                             
EOF

for i in {1..3}
do
    updateCheck 2>/tmp/hyprdots-systemupdate-error
    if [ ! -s /tmp/hyprdots-systemupdate-error ]; then
        # echo "Nice"
        break
        # echo $i
    fi
done
rm -fr /tmp/hyprdots-systemupdate-error
if [ "$upd" -eq 0 ]; then
    updateExit
    read -n 1 -s -t 3
exit 0
fi

 updatePackages ; updateExit 
read -n 1 -s -t 3
exit 0
fi

updateCheck


 if [ $upd -eq 0 ] ; then
                            # upd="" #Remove Icon completely
                            upd="󰮯"   #If zero Display Icon only
                           notify-send -a " 󰮯  " "System Update" "  Packages are up to date"
                            echo "{\"text\":\"$upd\", \"tooltip\":\" Packages are up to date\"}"
                        else
                            notify-send -a " 󰮯  " "System Update" "󱓽 Official $ofc\n󱓾 AUR $aur$fpk_disp"
                            echo "{\"text\":\"󰮯 $upd\", \"tooltip\":\"󱓽 Official $ofc\n󱓾 AUR $aur$fpk_disp\"}"
                        fi
