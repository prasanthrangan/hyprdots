#!/bin/bash
#|---/ /+--------------------------+---/ /|#
#|--/ /-| Main installation script |--/ /-|#
#|-/ /--| Prasanth Rangan          |-/ /--|#
#|/ /---+--------------------------+/ /---|#

source global_fn.sh

./install_pkg.sh custom_pkg.lst
./install_pkg.sh custom_hypr.lst
./install_pkg.sh custom_zsh.lst
./install_pkg.sh custom_ext.lst

./install_fnt.sh
./install_cfg.sh
#./install_oth.sh
#./install_sgz.sh

sudo ./enable_ctl.sh bluetooth
#sudo ./enable_ctl.sh sddm

