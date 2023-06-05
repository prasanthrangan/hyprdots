#!/bin/bash

if [ -d "$HOME/.local/bin" ] 
then
    echo "Directory /path/to/dir exists." 
else
    mkdir -p $HOME/.local/bin
fi

cp ../Configs/.local/bin/* $HOME/.local/bin
sudo cp ~/.local/bin/changebrightness /usr/local/bin/ 
