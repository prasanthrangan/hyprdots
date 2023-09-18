#!/bin/bash
#|---/ /+---------------------------+---/ /|#
#|--/ /-| Script to mount my drives |--/ /-|#
#|-/ /--| Prasanth Rangan           |-/ /--|#
#|/ /---+---------------------------+/ /---|#

# function to check device parameters

chk_blk()
{
    local BlkParm=$1
    local MyDrive=$2
    local ChkFlag=$3

    BlkVal=`lsblk --noheadings --raw -o $BlkParm $MyDrive`

    if [ ! -z $BlkVal ] && [ $ChkFlag == 'y' ] ; then
        #echo "$MyDrive : $BlkParm is $BlkVal"
        return 0

    elif [ -z $BlkVal ] && [ $ChkFlag == 'n' ] ; then
        #echo "$MyDrive : $BlkParm not available"
        return 0

    else
        return 1
    fi
}

ext_lab()
{
    local MyMount=$1
    local MyLabel=$2
    local MyDrive=""

    MyDrive=`findmnt --mountpoint $MyMount --noheadings -o source`
    if [ `lsblk --noheadings --raw -o fstype $MyDrive` == "ext4" ] && chk_blk label $MyDrive n ; then
        sudo e2label $MyDrive $MyLabel
    fi
}


# main loop to mount listed partition

while read dev_part
do
    if chk_blk uuid $dev_part y && chk_blk label $dev_part y && chk_blk mountpoint $dev_part n ; then

        dev_label=`lsblk --noheadings --raw -o label $dev_part`
        dev_uuid=`lsblk --noheadings --raw -o uuid $dev_part`
        dev_fstype=`lsblk --noheadings --raw -o fstype $dev_part`

        if [ ! -d /mnt/$dev_label ] ; then
            sudo mkdir /mnt/$dev_label
            echo "/mnt/$dev_label dir created..."
        fi

        if [ `grep $dev_uuid /etc/fstab | wc -l` -eq 0 ] ; then
            fstEntry=`echo -e "${fstEntry}\n# $dev_part \nUUID=$dev_uuid   /mnt/$dev_label \t$dev_fstype \t\tnosuid,nodev,nofail,x-gvfs-show \t 0  0\n "`
        fi

        sudo mount $dev_part /mnt/$dev_label
    fi
done < mnt_drives.lst

echo -e "${fstEntry}\n" | sudo tee -a /etc/fstab
sudo systemctl daemon-reload

ext_lab '/home' '9S'
ext_lab '/' 'YoRHa'

