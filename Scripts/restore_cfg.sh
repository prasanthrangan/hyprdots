#!/bin/bash
#|---/ /+------------------------------------+---/ /|#
#|--/ /-| Script to restore personel configs |--/ /-|#
#|-/ /--| Prasanth Rangan                    |-/ /--|#
#|/ /---+------------------------------------+/ /---|#

source global_fn.sh

CfgDir=`echo $CloneDir/Configs`
BkpDir="${HOME}/.config/$(date +'cfg_%y%m%d_%Hh%Mm%Ss')"

if [ -d $BkpDir ]
    then
    echo "ERROR : $BkpDir exists!"
    exit 1
else
    mkdir $BkpDir
fi

while read lst
do

    pth=`echo $lst | awk -F '|' '{print $1}'`
    cfg=`echo $lst | awk -F '|' '{print $2}'`
    pkg=`echo $lst | awk -F '|' '{print $3}'`
    pth=`eval echo $pth`

    while read pkg_chk
    do
        if ! pkg_installed $pkg_chk
            then
            echo "package $pkg_chk not found..."
            continue 2
        fi
    done < <( echo "${pkg}" | xargs -n 1 )

    echo "${cfg}" | xargs -n 1 | while read cfg_chk
    do
        tgt=`echo $pth | sed "s+^${HOME}++g"`
        
        if [ -d $pth/$cfg_chk ] || [ -f $pth/$cfg_chk ]
            then
            mv $pth/$cfg_chk $BkpDir
            echo "backed up $pth/$cfg_chk to ${BkpDir}..."
        fi 

        cp -r $CfgDir$tgt/$cfg_chk $pth
        echo "config $CfgDir$tgt/$cfg_chk restored to ${pth}..."
    done

done < restore_conf.lst

