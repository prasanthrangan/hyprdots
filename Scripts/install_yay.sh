#!/bin/bash
#|---/ /+-----------------------------------+---/ /|#
#|--/ /-| Script to install aur helper, yay |--/ /-|#
#|-/ /--| Prasanth Rangan                   |-/ /--|#
#|/ /---+-----------------------------------+/ /---|#

source global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname $(realpath $0))..."
    exit 1
fi

if pkg_installed yay
then
    exit 0
fi

if [ -d ~/Clone ]
then
    echo "~/Clone directory exists..."
    rm -rf ~/Clone/yay
else
    mkdir ~/Clone
    echo -e "[Desktop Entry]\nIcon=default-folder-git" > ~/Clone/.directory
    echo "~/Clone directory created..."
fi

if pkg_installed git
then
    git clone https://aur.archlinux.org/yay.git ~/Clone/yay
else
    echo "git dependency is not installed..."
    exit 1
fi

cd ~/Clone/yay
makepkg ${use_default} -si

if [ $? -eq 0 ]
then
    cd ~
    echo "aur helper installed, yayyy..."
    exit 0
else
    cd ~
    echo "yay installation failed..."
    exit 1
fi

