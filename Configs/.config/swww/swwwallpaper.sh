#!/usr/bin/env sh

Wall_Next()
{
    local WallNxt=$1
    if [ -f $WallNxt ] && [ ! -z $WallNxt ]
        then
        Wallist=(`dirname $WallNxt`/*)

        for((i=0;i<${#Wallist[@]};i++))
        do
            if [ $((i + 1)) -eq ${#Wallist[@]} ]
                then
                echo ${Wallist[0]} > $BASEDIR/wall.conf
                Wall_Set ${Wallist[0]}
                break
            elif [ ${Wallist[i]} == ${WallNxt} ]
                then
                echo ${Wallist[i+1]} > $BASEDIR/wall.conf
                Wall_Set ${Wallist[i+1]}
                break   
            fi
        done
    fi
}

Wall_Set()
{
    local WallSet=$1
    if [ -f $WallSet ] && [ ! -z $WallSet ]
        then
        swww img $WallSet \
        --transition-bezier .43,1.19,1,.4 \
        --transition-type grow \
        --transition-duration 1 \
        --transition-fps 144 \
        --transition-pos bottom-right &
    fi
}

if [ "$1" == "--help" ] ;
    then
    echo ""
    echo "󰋫 Next Wallpaper 󰉼 󰆊"
else
    BASEDIR=$(dirname "$0")
    touch $BASEDIR/wall.conf
    Wall=`head -1 $BASEDIR/wall.conf`
    swww query
    if [ $? -eq 1 ]
        then
        swww init
        sleep 3
        Wall_Set $Wall
    else
        Wall_Next $Wall
    fi
fi

