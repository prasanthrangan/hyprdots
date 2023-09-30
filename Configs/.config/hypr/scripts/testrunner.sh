#!/usr/bin/env sh

ScrDir=`dirname $(realpath $0)`
WalDir="$HOME/.config/swww"
WalCtl="$WalDir/wall.ctl"
RofDir="$HOME/.config/rofi"

roficn=0
wlogcn=1
hyprctl dispatch workspace 11

while read loop_theme
do
    themeName=`echo $loop_theme | cut -d '|' -f 2`
    $ScrDir/themeswitch.sh -s $themeName &> /dev/null
    sleep 0.2

    #walln=`ls -l $WalDir/$themeName | wc -l`
    for (( i=1 ; i<3 ; i++ ))
    do
        # swww
        sleep 0.2
        $ScrDir/swwwallpaper.sh -n &> /dev/null

        # rofiselect
        $ScrDir/rofiselect.sh &> /dev/null &
        sleep 0.7
        pkill rofi

        # rofi
        if [ $roficn -lt 8 ] ; then
            roficn=$(( roficn + 1 ))
        else
            roficn=1
        fi
        cp $RofDir/styles/style_$roficn.rasi $RofDir/config.rasi
        $ScrDir/rofilaunch.sh &> /dev/null &
        sleep 0.7
        pkill rofi

        # themeselect
        $ScrDir/themeselect.sh &> /dev/null &
        sleep 0.7
        pkill rofi

        # wlogout
        if [ $wlogcn -eq 1 ] ; then
            wlogcn=2
        else
            wlogcn=1
        fi
        $ScrDir/logoutlaunch.sh $wlogcn &> /dev/null &
        sleep 0.7
        pkill wlogout

        # waybar
        $ScrDir/wbarconfgen.sh n &> /dev/null

        # quickapps
        $ScrDir/quickapps.sh kitty firefox spotify code dolphin &> /dev/null &
        sleep 0.7
        pkill rofi

        # cliphist
        $ScrDir/cliphist.sh w &> /dev/null &
        sleep 0.7
        pkill rofi

        # wallselect
        $ScrDir/swwwallselect.sh &> /dev/null &
        sleep 0.7
        pkill rofi

        # wallbash
        $ScrDir/togglewallbash.sh
        sleep 0.2
    done
done < $WalCtl

