#!/bin/bash
#|---/ /+---------------------------------+---/ /|#
#|--/ /-| Script to fix slinks in .config |--/ /-|#
#|-/ /--| Prasanth Rangan                 |-/ /--|#
#|/ /---+---------------------------------+/ /---|#

source global_fn.sh

find $CloneDir -type l | while read slink
do
    read_slink=`readlink $slink`
    fixd_slink=`echo $read_slink | awk -F '/.config/' '{print $NF}'`
    linkd_file=`echo $slink | awk -F '/.config/' '{print $NF}'`
    echo "linking $HOME/.config/$linkd_file --> $HOME/.config/$fixd_slink..."
    ln -fs $HOME/.config/$fixd_slink $HOME/.config/$linkd_file
done

