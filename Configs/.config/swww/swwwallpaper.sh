#!/usr/bin/env sh

## define functions
Wall_Next()
{
    WallSet=`readlink $BASEDIR/wall.set`
    Wallist=(`dirname $WallSet`/*)

    for((i=0;i<${#Wallist[@]};i++))
    do
        if [ $((i + 1)) -eq ${#Wallist[@]} ] ; then
            ln -fs ${Wallist[0]} $BASEDIR/wall.set
            break
        elif [ ${Wallist[i]} == ${WallSet} ] ; then
            ln -fs ${Wallist[i+1]} $BASEDIR/wall.set
            break
        fi
    done
}

Wall_Set()
{
    swww img $BASEDIR/wall.set \
    --transition-bezier .43,1.19,1,.4 \
    --transition-type grow \
    --transition-duration 1 \
    --transition-fps 144 \
    --transition-pos bottom-right &
}

## display tooltip
if [ "$1" == "--help" ] ; then
    echo ""
    echo "󰋫 Next Wallpaper 󰉼 󰆊"
else

    BASEDIR=`dirname $(realpath $0)`

    ## wallpaper check
    if [ ! -f $BASEDIR/wall.set ] ; then
        echo "ERROR: current wallpaper not found, setting default"
        if [ -f $BASEDIR/walls/rain_world1.png ] ; then
            ln -fs $BASEDIR/walls/rain_world1.png $BASEDIR/wall.set
        else
            echo "ERROR: default wallpaper not found"
            exit 1
        fi
    fi

    ## daemon check and init
    swww query
    if [ $? -eq 1 ] ; then
        swww init
        sleep 2.5
        Wall_Set
    fi

    ## set the next wallpaper
    if [ "$1" == "--next" ] ; then
        Wall_Next
        Wall_Set
    fi

fi
