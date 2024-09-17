#!/usr/bin/env bash
#|---/ /+----------------------------------------+---/ /|#
#|--/ /-| Script to install qwerty-fr            |--/ /-|#
#|-/ /--| Matthieu Amet                          |-/ /--|#
#|-/ /--| Prasanth Rangan                        |-/ /--|#
#|/ /---+----------------------------------------+/ /---|#

curl -s https://api.github.com/repos/qwerty-fr/qwerty-fr/releases/latest \
| grep "browser_download_url.*.deb" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -
sudo dpkg -i ${scrDir}/*.deb
sudo rm -rf ${scrDir}/*.deb
