#!/usr/bin/env sh

term=$(cat $HOME/.config/hypr/keybindings.conf | grep ^'$term' | cut -d '=' -f2)

list="cmatrix -r"
if command -v $list &> /dev/null; then
    $term -e $list
fi