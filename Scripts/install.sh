#!/bin/bash
#|---/ /+--------------------------+---/ /|#
#|--/ /-| Main installation script |--/ /-|#
#|-/ /--| Prasanth Rangan          |-/ /--|#
#|/ /---+--------------------------+/ /---|#

#--------------------------------#
# import variables and functions #
#--------------------------------#
source global_fn.sh

#-------------------------------#
# install packages from my list #
#-------------------------------#
cat custom_hypr.lst custom_main.lst custom_zsh.lst > install_pkg.lst
./install_pkg.sh install_pkg.lst
#./install_pkg.sh custom_app.lst
#./install_fpk.sh

#---------------------------#
# restore my custom configs #
#---------------------------#
./restore_fnt.sh
./restore_cfg.sh
./restore_sgz.sh
#./restore_app.sh

#------------------------#
# enable system services #
#------------------------#
service_ctl NetworkManager
service_ctl bluetooth
service_ctl sddm

