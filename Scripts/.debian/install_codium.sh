#!/usr/bin/env bash
#|---/ /+----------------------------------------+---/ /|#
#|--/ /-| Script to install codium               |--/ /-|#
#|-/ /--| Matthieu Amet                          |-/ /--|#
#|-/ /--| Prasanth Rangan                        |-/ /--|#
#|/ /---+----------------------------------------+/ /---|#

wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update && sudo apt install codium
