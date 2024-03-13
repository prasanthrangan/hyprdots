#!/bin/bash
#|---/ /+---------------------------------+---/ /|#
#|--/ /-| Script to fix slinks in .config |--/ /-|#
#|-/ /--| Prasanth Rangan                 |-/ /--|#
#|/ /---+---------------------------------+/ /---|#

source global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname "$(realpath "$0")")..."
    exit 1
fi

find $CloneDir -type l | while read slink
do
    fixd_slink=$(readlink $slink | cut -d '/' -f 4-)
    linkd_file=$(echo $slink | awk -F "${CloneDir}/Configs/" '{print $NF}')
    echo "linking $HOME/$linkd_file --> $HOME/$fixd_slink..."
    ln -fs $HOME/$fixd_slink $HOME/$linkd_file
done

if [ -f $HOME/.config/hyprdots/scripts/globalcontrol.sh ] ; then
    sed -i "/^CloneDir=/c\CloneDir=\"$CloneDir\"" $HOME/.config/hyprdots/scripts/globalcontrol.sh
    echo "Clone directory globalcontrol updated..."
fi

if printenv HYPRLAND_INSTANCE_SIGNATURE &> /dev/null
    then
    echo "reloading hyprland..."
    hyprctl reload
fi

