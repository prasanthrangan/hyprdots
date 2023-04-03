#!/bin/bash
#|---/ /+-----------------------------+---/ /|#
#|--/ /-| Script to clone my git repo |--/ /-|#
#|-/ /--| Prasanth Rangan             |-/ /--|#
#|/ /---+-----------------------------+/ /---|#

source global_fn.sh

if pkg_installed git
then
    if [ -d ~/Dots ]
    then
        echo "~/Dots directory exists..."
        cd ~/Dots
        git status
    else
        mkdir ~/Dots
        echo "~/Dots directory created..."
        git clone https://github.com/prasanthrangan/dotfiles.git ~/Dots
    fi
else
    echo "git is not installed..."
    exit 1
fi

if [[ `grep '@github.com' ~/Dots/.git/config | awk '{print $1}'` == "url" ]]
then
    git pull --rebase
    if [ `git config --list | grep -E "user.email|user.name" | wc -l` -eq 2 ]
    then
        git add .
        git status
        git commit -m "updates"
        git push
    fi
else
    echo "git token not configured..."
    echo 'sed -i "/url = /c\\\turl = https://prasanthrangan:<token>@github.com/prasanthrangan/dotfiles.git" ~/Dots/.git/config'
    exit 0
fi
