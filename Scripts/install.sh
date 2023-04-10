#!/bin/bash
#|---/ /+--------------------------+---/ /|#
#|--/ /-| Main installation script |--/ /-|#
#|-/ /--| Prasanth Rangan          |-/ /--|#
#|/ /---+--------------------------+/ /---|#

source global_fn.sh

./install_pkg.sh custom_hypr.lst
./install_pkg.sh custom_main.lst
./install_pkg.sh custom_zsh.lst
./install_pkg.sh custom_app.lst

./restore_fnt.sh
./restore_cfg.sh
./restore_sgz.sh
#./restore_app.sh

#sudo ./enable_ctl.sh bluetooth
#sudo ./enable_ctl.sh sddm

