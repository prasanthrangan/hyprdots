#!/bin/bash
#|---/ /+------------------------------------+---/ /|#
#|--/ /-| Script to restore personal configs |--/ /-|#
#|-/ /--| Prasanth Rangan                    |-/ /--|#
#|/ /---+------------------------------------+/ /---|#

source global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname "$(realpath "$0")")..."
    exit 1
fi

ThemeOverride="${1:-}"              #override default config list with custom theme list [param 1]
CfgDir="${2:-${CloneDir}/Configs}"  #override default config path with custom theme path [param 2]

if [ ! -f "${ThemeOverride}manage_config.lst" ] || [ ! -d "${CfgDir}" ] ; then
    echo "ERROR : '${ThemeOverride}manage_config.lst' or '${CfgDir}' does not exist..."
    exit 1
fi

BkpDir="${HOME}/.config/cfg_backups/$(date +'%y%m%d_%Hh%Mm%Ss')"

        if [ -d "${BkpDir}" ] ; then
    echo "ERROR : ${BkpDir} exists!"
    exit 1
else
    mkdir -p "${BkpDir}"
fi


cat "${ThemeOverride}manage_config.lst" | while read lst
do

    ctlFlag=$(echo "${lst}" | awk -F '|' '{print $1}')
    pth=$(echo "${lst}" | awk -F '|' '{print $2}')
    pth=$(eval echo "${pth}")
    cfg=$(echo "${lst}" | awk -F '|' '{print $3}')
    pkg=$(echo "${lst}" | awk -F '|' '{print $4}')

# Check if ctlFlag is not one of the values 'O', 'R', 'B', 'S', or 'P'
if [[ "${ctlFlag}" != "O" && "${ctlFlag}" != "R" && "${ctlFlag}" != "B" && "${ctlFlag}" != "S" && "${ctlFlag}" != "P" && "${ctlFlag}" != "U"  ]]; then
echo "[IGNORED] ${pth}/${cfg}"
    continue 2
fi

# Start a loop that reads each line from the output of the command enclosed within the process substitution '< <(...)'
while read -r pkg_chk
do


    # Call the function pkg_installed with the argument pkg_chk. If the function returns false (the package is not installed), then...
    if ! pkg_installed ${pkg_chk} 
        then
        # Print a message stating that the current configuration is being skipped because a dependency is not installed
        echo "[NEED] '${pkg_chk}' as dependency  ${pth}/${cfg} skipped..."
        # Skip the rest of the current loop iteration and proceed to the next iteration
        continue 2
    fi
done < <( echo "${pkg}" | xargs -n 1 )

# Pipe the value of cfg to xargs, which splits it into separate arguments based on spaces, and then pipe the output to a while loop
echo "${cfg}" | xargs -n 1 | while read -r cfg_chk
do

# cat << EOF
#  control Flag =  $ctlFlag  
# Path  = $pth
# configs = $cfg
# package = $pkg
# EOF
        # Check if the variable pth is empty, if it is, skip the current iteration
        if [[ -z "${pth}" ]]; then continue; fi

# Remove the HOME directory from the beginning of the path stored in pth and store the result in tgt
tgt=$(echo "${pth}" | sed "s+^${HOME}++g")
crnt_cfg="${pth}/${cfg_chk}"

    if [ ! -e "${CfgDir}$tgt/${cfg_chk}" ]; then
        echo "Source directory ${CfgDir}$tgt/${cfg_chk} does not exist, skipping..."
        continue
    fi

        if [ -e "${crnt_cfg}" ]; then
        # echo "Files exist: ${crnt_cfg}"
            # Check if the directory specified by BkpDir and tgt exists, if it doesn't, create it
            if [ ! -d "${BkpDir}${tgt}" ] ; then mkdir -p "${BkpDir}${tgt}" ; fi

            case "${ctlFlag}" in
                "B")
                    echo "[Backup] ${pth}/${cfg_chk} --> ${BkpDir}${tgt}..."                                    
                    cp -r "${pth}/${cfg_chk}" "${BkpDir}${tgt}"    
                    ;;
                "O")
                    
                    mv "${pth}/${cfg_chk}" "${BkpDir}${tgt}" 
                    cp -r "${CfgDir}$tgt/${cfg_chk}" "${pth}"
                    echo "[Overwrite] ${pth} <-- ${CfgDir}${tgt}/${cfg_chk}"
                    ;;
                "R")
                echo "[Rsync]"
                    # Code to execute if ctlFlag is 'R'
                    ;;
                "S")
                echo "[Sync]"
                    # Code to execute if ctlFlag is 'S'                    
                    cp -rf "${CfgDir}$tgt/${cfg_chk}" "${pth}"        
                    ;;
                "U")
                    cp -rn "${CfgDir}$tgt/${cfg_chk}" "${pth}" || true && echo "[PRESERVED] "      
                    ;;
            esac
        else
        echo "[Populate]"                    
                    cp -rn "${CfgDir}$tgt/${cfg_chk}" "${pth}"        
        fi

                    # Check if the file or directory specified by pth/cfg_chk exists and if the backup flag is set to "Y"

#                         # If the overwrite flag is set to "Y", move the file or directory to the backup location, otherwise copy it
#                         [ "${ctlFlag}" == "Y" ] && mv "${pth}/${cfg_chk}" "${BkpDir}${tgt}" || cp -r "${pth}/${cfg_chk}" "${BkpDir}${tgt}"
#                         # Print a message indicating that the configuration has been backed up
#                         echo "config backed up ${pth}/${cfg_chk} --> ${BkpDir}${tgt}..."
                    
                    

# # Check if the directory specified by pth exists, if it doesn't, create it
# if [ ! -d "${pth}" ] ; then
#     mkdir -p "${pth}"
# fi

#                     # Check if the file specified by pth/cfg_chk exists
#                     if [ ! -f "${pth}/${cfg_chk}" ] ; then
#                         # Copy the file from the configuration directory to the target path
#                         cp -r "${CfgDir}${tgt}/${cfg_chk}" "${pth}"
#                         # Print a message indicating that the configuration has been restored
#                         echo "config restored ${pth} <-- ${CfgDir}${tgt}/${cfg_chk}..."
#                     elif [ "${ctlFlag}" == "Y" ] ; then
#                         # If the overwrite flag is set to "Y", copy the file from the configuration directory to the target path
#                         cp -r "${CfgDir}$tgt/${cfg_chk}" "${pth}"
#                         # Print a warning message indicating that the configuration was overwritten without a backup
#                         echo "warning: config overwritten without backup ${pth} <-- ${CfgDir}${tgt}/${cfg_chk}..."
#                     else
#                         # If neither of the above conditions are met, print a message indicating that the operation was skipped
#                         echo "Skipping ${pth}/${cfg_chk} to preserve user setting..."
#                     fi




    done

done

# if nvidia_detect && [ $(grep '^source = ~/.config/hypr/nvidia.conf' ${HOME}/.config/hypr/hyprland.conf | wc -l) -eq 0 ] ; then
#     echo -e 'source = ~/.config/hypr/nvidia.conf # auto sourced vars for nvidia\n' >> ${HOME}/.config/hypr/hyprland.conf
# fi

# ./create_cache.sh
 ./restore_lnk.sh
