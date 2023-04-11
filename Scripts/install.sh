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
./install_pkg.sh custom_hypr.lst
./install_pkg.sh custom_main.lst
./install_pkg.sh custom_zsh.lst
#./install_pkg.sh custom_app.lst

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
sudo ./enable_ctl.sh NetworkManager
sudo ./enable_ctl.sh bluetooth
sudo ./enable_ctl.sh sddm

