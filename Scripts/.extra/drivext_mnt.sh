#!/usr/bin/env bash
#|---/ /+---------------------------+---/ /|#
#|--/ /-| Script to mount my drives |--/ /-|#
#|-/ /--| Prasanth Rangan           |-/ /--|#
#|/ /---+---------------------------+/ /---|#

while read -r fst uuid name; do

    label=$(lsblk --noheadings --raw -o LABEL "${name}")
    mount=$(lsblk --noheadings --raw -o MOUNTPOINT "${name}")

    if [ "${mount}" == "/" ] && [ -z "${label}" ]; then
        sudo e2label "${name}" "YoRHa"

    elif [ "${mount}" == "/home" ] && [ -z "${label}" ]; then
        sudo e2label "${name}" "9S"

    elif [ -z "${mount}" ] && [ ! -z "${label}" ] && [ $(grep "${uuid}" /etc/fstab | wc -l) -eq 0 ]; then
        [ ! -d "/mnt/${label}" ] && sudo mkdir -p "/mnt/${label}"
        fstEntry=$(echo -e "${fstEntry}\n#/${name}\nUUID=${uuid}    /mnt/${label}    ${fst}    nosuid,nodev,nofail,x-gvfs-show    0  0\n ")
        sudo mount "${name}" "/mnt/${label}"

    else
        continue
    fi

done < <(lsblk --noheadings --raw -o TYPE,FSTYPE,UUID,NAME | awk '{if ($1=="part" && $2=="ext4") print $2, $3, "/dev/" $4}')

if [ ! -z "${fstEntry}" ]; then
    echo -e "${fstEntry}\n" | sudo tee -a /etc/fstab
    sudo systemctl daemon-reload
fi
