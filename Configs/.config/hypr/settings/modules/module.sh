#!/bin/bash
_getHeader "$name" "$author"
echo "ML4W dotfiles Version" $(cat $HOME/dotfiles/.version/name)
echo
echo "$homepage ($email)"
echo
echo $description
