#!/usr/bin/env sh

# set variables

ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh
dcoDir="$HOME/.config/hypr/wallbash"
input_wall=$1

if [ -z "$input_wall" ] || [ ! -f ${input_wall} ] ; then
    echo "Error: Input wallpaper not found!"
    exit 1
fi


# extract dcols

if [ ! -f "${input_wall}.dcol" ] ; then
    magick ${input_wall} -colors 4 -define histogram:unique-colors=true -format "%c" histogram:info: > ${input_wall}.dcol
fi

dcol=( $(awk '{print substr($3,1,7)}' ${input_wall}.dcol | sort) )


# loop thru templates 

find "$dcoDir" -name "*.dcol" | while read tplt
do
    dcolct=`head -1 $tplt | cut -d '|' -f 1`
    appexe=`head -1 $tplt | cut -d '|' -f 2`
    target=`head -1 $tplt | cut -d '|' -f 3`

    if [ "$EnableWallDcol" -eq 1 ] ; then
        sed '1d' $tplt > $HOME/$target
        for (( i=0 ; i<${dcolct} ; i++ ))
        do
            if [ -z "${dcol[i]}" ] ; then
                dcol[i]="${dcol[i-1]}"
            fi
            sed -i "s/<dcol_${i}>/${dcol[i]}/g" $HOME/$target
        done
    fi

    $ScrDir/$appexe
done

