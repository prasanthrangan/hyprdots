#!/bin/bash
#|---/ /+----------------------------------+---/ /|#
#|--/ /-| Script to install fonts & themes |--/ /-|#
#|-/ /--| Prasanth Rangan                  |-/ /--|#
#|/ /---+----------------------------------+/ /---|#

source global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname $(realpath $0))..."
    exit 1
fi

while read lst
do

    fnt=`echo $lst | awk -F '|' '{print $1}'`
    tgt=`echo $lst | awk -F '|' '{print $2}'`
    tgt=`eval "echo $tgt"`

    if [ ! -d "${tgt}" ]
    then
        mkdir -p ${tgt}
        echo "${tgt} directory created..."
    fi

    sudo tar -xzf ${CloneDir}/Source/arcs/${fnt}.tar.gz -C ${tgt}/
    echo "uncompressing ${fnt}.tar.gz --> ${tgt}..."

done < restore_font.lst

echo "rebuilding font cache..."
fc-cache -f

