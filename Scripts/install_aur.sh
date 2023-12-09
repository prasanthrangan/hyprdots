#!/bin/bash
#|---/ /+-----------------------------------+---/ /|#
#|--/ /-| Script to install aur helper, yay |--/ /-|#
#|-/ /--| Prasanth Rangan                   |-/ /--|#
#|/ /---+-----------------------------------+/ /---|#

source global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname "$(realpath "$0")")..."
    exit 1
fi

aurhlpr="${1:-yay}"

if pkg_installed yay || pkg_installed paru
then
    echo "aur helper is already installed..."
    exit 0
fi

if [ -d ~/Clone ]
then
    echo "~/Clone directory exists..."
    rm -rf ~/Clone/$aurhlpr
else
    mkdir ~/Clone
    echo -e "[Desktop Entry]\nIcon=default-folder-git" > ~/Clone/.directory
    echo "~/Clone directory created..."
fi

if pkg_installed git
then
    git clone https://aur.archlinux.org/$aurhlpr.git ~/Clone/$aurhlpr
else
    echo "git dependency is not installed..."
    exit 1
fi

cd ~/Clone/$aurhlpr
makepkg ${use_default} -si

if [ $? -eq 0 ]
then
    echo "$aurhlpr aur helper installed..."
    exit 0
else
    echo "$aurhlpr installation failed..."
    exit 1
fi
