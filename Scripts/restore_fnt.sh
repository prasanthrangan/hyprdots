#!/bin/bash
#|---/ /+----------------------------------+---/ /|#
#|--/ /-| Script to extract fonts & themes |--/ /-|#
#|-/ /--| Prasanth Rangan                  |-/ /--|#
#|/ /---+----------------------------------+/ /---|#

source global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname $(realpath $0))..."
    exit 1
fi

cat restore_fnt.lst | while read lst
do

    bkpFlag=`echo $lst | awk -F '|' '{print $1}'`
    fnt=`echo $lst | awk -F '|' '{print $2}'`
    tgt=`echo $lst | awk -F '|' '{print $3}'`
    tgt=`eval "echo $tgt"`

    if [ ! -d "${tgt}" ] && [ "${bkpFlag}" == "Y" ]
    then
        mkdir -p ${tgt} || echo "creating the directory as root instead..." && sudo mkdir -p ${tgt}
        echo "${tgt} directory created..."
    fi

    if [ "${bkpFlag}" == "Y" ]; then
        sudo tar -xzf ${CloneDir}/Source/arcs/${fnt}.tar.gz -C ${tgt}/
        echo "uncompressing ${fnt}.tar.gz --> ${tgt}..."
    fi

done

echo "rebuilding font cache..."
fc-cache -f

