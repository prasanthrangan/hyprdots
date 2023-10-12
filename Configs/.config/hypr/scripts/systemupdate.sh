#!/usr/bin/env bash

# source variables
ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh

# Trigger upgrade
if [ "$1" == "up" ] ; then
	# Trigger upgrade
    kitty --start-as fullscreen --title systemupdate sh -c "/home/khing/.config/hypr/scripts/systemupdate.sh now"
    #alacritty --title "System Updates" -e $HOME/.config/hypr/scripts/systemupdate.sh now
#Refresh waybar
killall waybar
waybar > /dev/null 2>&1 &
fi

if [ "$1" == "now" ] ; then
#!/usr/bin/env bash
echo "
    ███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗    ██╗   ██╗██████╗ ██████╗  █████╗ ████████╗███████╗
    ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║    ██║   ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝
    ███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║    ██║   ██║██████╔╝██║  ██║███████║   ██║   █████╗  
    ╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║    ██║   ██║██╔═══╝ ██║  ██║██╔══██║   ██║   ██╔══╝  
    ███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║    ╚██████╔╝██║     ██████╔╝██║  ██║   ██║   ███████╗
    ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝     ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝ 
"| lolcat
neofetch --no_config | lolcat
sudo pacman -Syu
paru -Syu # | lolcat
flatpak update #| lolcat
echo "
███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗    ██╗   ██╗██████╗ ██████╗  █████╗ ████████╗███████╗██████╗                     
██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║    ██║   ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██╔══██╗                    
███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║    ██║   ██║██████╔╝██║  ██║███████║   ██║   █████╗  ██║  ██║                    
╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║    ██║   ██║██╔═══╝ ██║  ██║██╔══██║   ██║   ██╔══╝  ██║  ██║                    
███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║    ╚██████╔╝██║     ██████╔╝██║  ██║   ██║   ███████╗██████╔╝                    
╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝     ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═════╝                     
" | lolcat
sleep 3
exit 0
fi

checkUpdate () {
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

# Show tooltip
if [ $upd -eq 0 ] ; then
     upd=""
 #   notify-send -a " 󰮯  " "System Update" "  Packages are up to date"
    echo "{\"text\":\"$upd\", \"tooltip\":\" Packages are up to date\"}"
else
    notify-send -a " 󰮯  " "System Update" "󱓽 Official $ofc\n󱓾 AUR $aur$fpk_disp"
    echo "{\"text\":\"󰮯 $upd\", \"tooltip\":\"󱓽 Official $ofc\n󱓾 AUR $aur$fpk_disp\"}"
fi
}


checkUpdate