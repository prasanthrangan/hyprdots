#!/usr/bin/env sh

swww query
if [ $? -eq 1 ]
    then
    swww init
fi

WallDir="$HOME/Dots/Wallpapers"
WallChk=`swww query | awk '{print $NF}' | sed 's/"//g'`

if [ $WallChk == "000" ]

    then
    WallSet="${WallDir}/rain_world1.png"

else

    Wallist=(${WallDir}/*)
    for((i=1;i<=${#Wallist[@]};i++))
    do
        if [ $i -eq ${#Wallist[@]} ]
            then
            WallSet=${Wallist[0]}
            break

        elif [ ${Wallist[i-1]} == ${WallDir}/${WallChk} ]
            then
            WallSet=${Wallist[i]}
            break

        fi
    done

fi

swww img $WallSet \
--transition-type grow \
--transition-duration 2 \
--transition-fps 144 \
--transition-pos bottom-right

