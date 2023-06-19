#!/usr/bin/env sh

## define functions ##
Wall_Prev()
{
    for (( i=0 ; i<${#Wallist[@]} ; i++ ))
    do
        if [ ${Wallist[i]} == ${getWall2} ] ; then
            ws=${Wallist[i-1]/$HOME/"~"}
            sed -i "s+${getWall1}+${ws}+" $BaseDir/wall.ctl
            ln -fs ${Wallist[i-1]} $BaseDir/wall.set
            break
        fi
    done
}

Wall_Next()
{
    for (( i=0 ; i<${#Wallist[@]} ; i++ ))
    do
        if [ ${Wallist[i]} == ${getWall2} ] ; then
            nextIndex=$(( (i + 1) % ${#Wallist[@]} ))
            ws=${Wallist[nextIndex]/$HOME/"~"}
            sed -i "s+${getWall1}+${ws}+" $BaseDir/wall.ctl
            ln -fs ${Wallist[nextIndex]} $BaseDir/wall.set
            break
        fi
    done
}

Wall_Set()
{
    if [ -z $xtrans ] ; then
        xtrans="grow"
    fi

    swww img $BaseDir/wall.set \
    --transition-bezier .43,1.19,1,.4 \
    --transition-type $xtrans \
    --transition-duration 1 \
    --transition-fps 60 \
    --transition-pos bottom-right
}

## set variables ##
BaseDir=`dirname $(realpath $0)`

if [ `grep '^1|' $BaseDir/wall.ctl | wc -l` -ne 1 ] ; then
    echo "ERROR : $BaseDir/wall.ctl Unable to fetch theme..."
    exit 1
fi

getWall1=`grep '^1|' $BaseDir/wall.ctl | cut -d '|' -f 3`
getWall2=`eval echo $getWall1`

if [ ! -f $getWall2 ] ; then
    echo "ERROR : $getWall2 Wallpaper not found..."
    exit 1
fi

if [ ! -f $BaseDir/wall.set ] ; then
    echo "ERROR: wallpaper link is broken"
    exit 1
fi

Wallist=(`dirname $getWall2`/*)

## evaluate options ##
while getopts "npt" option ; do
    case $option in
    n ) # set the next wallpaper
        xtrans="grow"
        Wall_Next ;;
    p ) # set the previous wallpaper
        xtrans="outer"
        Wall_Prev ;;
    t ) # display tooltip
        echo ""
        echo "󰆊 Next/Previous Wallpaper"
        exit 0 ;;
    * ) # invalid option
        echo "n : set next wall"
        echo "p : set previous wall"
        echo "t : display tooltip"
        exit 1 ;;
    esac
done

## check swww daemon ##
swww query
if [ $? -eq 1 ] ; then
    swww init
fi

## set wallpaper ##
Wall_Set
convert -scale 10% -blur 0x2 -resize 100% $BaseDir/wall.set $BaseDir/wall.blur

