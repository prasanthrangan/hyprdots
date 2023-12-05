#!/bin/bash
#|---/ /+--------------------------------------+---/ /|#
#|--/ /-| Script to compare git and local dots |--/ /-|#
#|-/ /--| Prasanth Rangan                      |-/ /--|#
#|/ /---+--------------------------------------+/ /---|#

source global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname "$(realpath "$0")")..."
    exit 1
fi

CfgDir=`echo $CloneDir/Configs`

while read lst
do

    pth=`echo $lst | awk -F '|' '{print $1}'`
    cfg=`echo $lst | awk -F '|' '{print $2}'`
    pth=`eval echo $pth`

    echo "${cfg}" | xargs -n 1 | while read cfg_chk
    do
        tgt=`echo $pth | sed "s+^${HOME}++g"`
        if [ `diff -qr --no-dereference ${pth}/$cfg_chk $CfgDir$tgt/$cfg_chk | wc -l` -gt 0 ]
            then
            echo "diff found ${pth}/$cfg_chk <--> $CfgDir$tgt/$cfg_chk"
        fi
    done

done < restore_conf.lst

