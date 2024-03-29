#!/usr/bin/env sh

scrDir=`dirname "$(realpath "$0")"`
source $scrDir/globalcontrol.sh
WalDir="${XDG_CONFIG_HOME:-$HOME/.config}/swww"
RofDir="${XDG_CONFIG_HOME:-$HOME/.config}/rofi"

roficn=0
wlogcn=1

while read loop_theme
do
    themeName=`echo $loop_theme | cut -d '|' -f 2`
    $scrDir/themeswitch.sh -s $themeName &> /dev/null
    sleep 0.2

    hyprctl dispatch workspace empty
    dolphin &> /dev/null &
    sleep 0.21
    kitty &> /dev/null &
    sleep 1.4
    hyprctl dispatch workspace empty

    #walln=`ls -l $WalDir/$themeName | wc -l`
    for (( i=1 ; i<3 ; i++ ))
    do
        # swww
        sleep 0.2
        $scrDir/swwwallpaper.sh -n &> /dev/null

        # rofiselect
        $scrDir/rofiselect.sh &> /dev/null &
        sleep 0.7
        pkill -x rofi

        # rofi
        if [ $roficn -lt 8 ] ; then
            roficn=$(( roficn + 1 ))
        else
            roficn=1
        fi
        cp $RofDir/styles/style_$roficn.rasi $RofDir/config.rasi
        $scrDir/rofilaunch.sh &> /dev/null &
        sleep 0.7
        pkill -x rofi

        # themeselect
        $scrDir/themeselect.sh &> /dev/null &
        sleep 0.7
        pkill -x rofi

        # wlogout
        if [ $wlogcn -eq 1 ] ; then
            wlogcn=2
        else
            wlogcn=1
        fi
        $scrDir/logoutlaunch.sh $wlogcn &> /dev/null &
        sleep 0.7
        pkill -x wlogout

        # waybar
        $scrDir/wbarconfgen.sh n &> /dev/null

        # quickapps
        $scrDir/quickapps.sh kitty firefox spotify code dolphin &> /dev/null &
        sleep 0.7
        pkill -x rofi

        # cliphist
        $scrDir/cliphist.sh w &> /dev/null &
        sleep 0.7
        pkill -x rofi

        # wallselect
        $scrDir/swwwallselect.sh &> /dev/null &
        sleep 0.7
        pkill -x rofi

        # wallbash
        $scrDir/wallbashtoggle.sh
        sleep 0.2

        # volumecontrol
        for (( i=1 ; i<=6 ; i++ )) ; do
            [[ i -gt 3 ]] && vol="d" || vol="i"
            $scrDir/volumecontrol.sh -o $vol
        done
    done
done < "$themeCtl"

