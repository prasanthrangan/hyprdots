#!/bin/bash
#|---/ /+------------------+---/ /|#
#|--/ /-| Global functions |--/ /-|#
#|-/ /--| Prasanth Rangan  |-/ /--|#
#|/ /---+------------------+/ /---|#

set -e

service_check()
{
    local ServChk=$1

    if [[ $(systemctl list-units --all -t service --full --no-legend "${ServChk}.service" | sed 's/^\s*//g' | cut -f1 -d' ') == "${ServChk}.service" ]]
    then
        #echo "${ServChk} service is running"
        return 0
    else
        #echo "${ServChk} service is not running"
        return 1
    fi
}

#config_check()
#{
#    local CfgChk=$1
#    if [ `find $HOME/Dots -name "${CfgChk}" | wc -w` -eq 1 ]
#    then
#        export cfgPath=`find $HOME/Dots -name "${CfgChk}" -exec dirname {} \;`
#        export tgtPath=`echo $cfgPath | sed "s,/Dots/Configs,,"`
#        return 0
#    else
#        return 1
#    fi
#}

pkg_installed()
{
    local PkgIn=$1

    if pacman -Qi $PkgIn > /dev/null
    then
        #echo "${PkgIn} is already installed..."
        return 0
    else
        #echo "${PkgIn} is not installed..."
        return 1
    fi
}

pkg_available()
{
    local PkgIn=$1

    if pacman -Si $PkgIn > /dev/null
    then
        #echo "${PkgIn} available in arch repo..."
        return 0
    else
        #echo "${PkgIn} not available in arch repo..."
        return 1
    fi
}

aur_available()
{
    local PkgIn=$1

    if pkg_installed yay
    then
        if yay -Si $PkgIn > /dev/null
        then
            #echo "${PkgIn} available in aur repo..."
            return 0
        else
            #echo "${PkgIn} not available in aur repo..."
            return 1
        fi
    else
        #echo "yay is not installed..."
        return 1
    fi
}
