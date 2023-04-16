#!/bin/bash
#|---/ /+------------------------------------+---/ /|#
#|--/ /-| Script to restore personel configs |--/ /-|#
#|-/ /--| Prasanth Rangan                    |-/ /--|#
#|/ /---+------------------------------------+/ /---|#

source global_fn.sh

cfgpath=`dirname $(dirname $(realpath $0))`
cfgpath=`echo $cfgpath/Configs`
bkpdir="${HOME}/.config/$(date +'cfg_%y%m%d_%Hh%Mm%Ss')"

if [ -d $bkpdir ]
then
    echo "$bkpdir exists"
    exit 1
else
    mkdir $bkpdir
fi

while read lst
do

    pth=`echo $lst | awk -F '|' '{print $1}'`
    cfg=`echo $lst | awk -F '|' '{print $2}'`
    pkg=`echo $lst | awk -F '|' '{print $3}'`
    pth=`eval echo $pth`

    echo "${pkg}" | xargs -n 1 | while read pkg_chk
    do
        if ! pkg_installed $pkg_chk
        then
            echo $pkg_chk not found
            continue
        fi
    done

    echo "${cfg}" | xargs -n 1 | while read cfg_chk
    do
        tgt=`echo $pth | sed "s+^${HOME}++g"`
        mv $pth/$cfg_chk $bkpdir
        echo "$pth/$cfg_chk backed up to $bkpdir"
        cp -r $cfgpath$tgt/$cfg_chk $pth
        echo "$cfgpath$tgt/$cfg_chk restored to $pth"
    done

done < restore_conf.lst
