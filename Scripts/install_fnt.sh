#!/bin/bash
#|---/ /+-------------------------+---/ /|#
#|--/ /-| Script to install fonts |--/ /-|#
#|-/ /--| Prasanth Rangan         |-/ /--|#
#|/ /---+-------------------------+/ /---|#

source global_fn.sh

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

sudo tar -xvzf ~/Dots/Source/arcs/${fnt}.tar.gz -C ${tgt}/

done < restore_fnt.lst

fc-cache -vf
fc-list
