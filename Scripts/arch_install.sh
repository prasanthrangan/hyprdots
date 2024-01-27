#!/usr/bin/env -S bash -e

# Cleaning the TTY.
clear


# Selecting the kernel flavor to install.
kernel_selector () {
    echo "List of kernels:"
    echo "1) Stable — Vanilla Linux kernel and modules, with a few patches applied."
    echo "2) Hardened — A security-focused Linux kernel."
    echo "3) Longterm — Long-term support (LTS) Linux kernel and modules."
    echo "4) Zen Kernel — Optimized for desktop usage."
    read -r -p "Insert the number of the corresponding kernel: " choice
    echo "$choice will be installed"
    case $choice in
        1 ) kernel=linux
            ;;
        2 ) kernel=linux-hardened
            ;;
        3 ) kernel=linux-lts
            ;;
        4 ) kernel=linux-zen
            ;;
        * ) echo "You did not enter a valid selection."
            kernel_selector
    esac
}

## user input ##

# Selecting the target for the installation.
PS3="Select the disk where Arch Linux is going to be installed: "
select ENTRY in $(lsblk -dpnoNAME|grep -P "/dev/sd|nvme|vd");
do
    DISK=$ENTRY
    echo "Installing Arch Linux on $DISK."
    break
done

# Confirming the disk selection.
read -r -p "This will delete the current partition table on $DISK. Do you agree [y/N]? " response
response=${response,,}
if [[ ! ("$response" =~ ^(yes|y)$) ]]; then
    echo "Quitting."
    exit
fi

#select kernel
kernel_selector

# Setting username.
read -r -p "Please enter name for a user account (leave empty to skip): " username

# Setting password.
if [[ -n $username ]]; then
    read -r -p "Please enter a password for the user account: " password
fi

# Choose locales.
read -r -p "Please insert the locale you use in this format (en_GB): " locale

# Choose keyboard layout.
read -r -p "Please insert the keyboard layout you use: " kblayout

## installation ##

# Updating the live environment usually causes more problems than its worth, and quite often can't be done without remounting cowspace with more capacity, especially at the end of any given month.
pacman -Sy

# Installing curl
pacman -S --noconfirm curl

# formatting the disk
wipefs -af "$DISK" &>/dev/null
sgdisk -Zo "$DISK" &>/dev/null

# Checking the microcode to install.
CPU=$(grep vendor_id /proc/cpuinfo)
if [[ $CPU == *"AuthenticAMD"* ]]; then
    microcode=amd-ucode
else
    microcode=intel-ucode
fi

# Creating a new partition scheme.
echo "Creating new partition scheme on $DISK."
parted -s "$DISK" \
    mklabel gpt \
    mkpart ESP fat32 1MiB 128MiB \
    set 1 esp on \
    mkpart cryptroot 128MiB 100% \

sleep 0.1
ESP="/dev/$(lsblk $DISK -o NAME,PARTLABEL | grep ESP| cut -d " " -f1 | cut -c7-)"
cryptroot="/dev/$(lsblk $DISK -o NAME,PARTLABEL | grep cryptroot | cut -d " " -f1 | cut -c7-)"

# Informing the Kernel of the changes.
echo "Informing the Kernel about the disk changes."
partprobe "$DISK"

# Formatting the ESP as FAT32.
echo "Formatting the EFI Partition as FAT32."
mkfs.fat -F 32 -s 2 $ESP &>/dev/null

# Creating a LUKS Container for the root partition.
echo "Creating LUKS Container for the root partition."
cryptsetup luksFormat --type luks1 $cryptroot
echo "Opening the newly created LUKS Container."
cryptsetup open $cryptroot cryptroot
BTRFS="/dev/mapper/cryptroot"

# Formatting the LUKS Container as BTRFS.
echo "Formatting the LUKS container as BTRFS."
mkfs.btrfs $BTRFS &>/dev/null
mount -o clear_cache,nospace_cache $BTRFS /mnt

# Creating BTRFS subvolumes.
echo "Creating BTRFS subvolumes."
btrfs su cr /mnt/@ &>/dev/null
btrfs su cr /mnt/@/.snapshots &>/dev/null
mkdir -p /mnt/@/.snapshots/1 &>/dev/null
btrfs su cr /mnt/@/.snapshots/1/snapshot &>/dev/null
btrfs su cr /mnt/@/boot/ &>/dev/null
btrfs su cr /mnt/@/home &>/dev/null
btrfs su cr /mnt/@/root &>/dev/null
btrfs su cr /mnt/@/srv &>/dev/null
btrfs su cr /mnt/@/var_log &>/dev/null
btrfs su cr /mnt/@/var_log_journal &>/dev/null
btrfs su cr /mnt/@/var_crash &>/dev/null
btrfs su cr /mnt/@/var_cache &>/dev/null
btrfs su cr /mnt/@/var_tmp &>/dev/null
btrfs su cr /mnt/@/var_spool &>/dev/null
btrfs su cr /mnt/@/var_lib_libvirt_images &>/dev/null
btrfs su cr /mnt/@/var_lib_machines &>/dev/null
btrfs su cr /mnt/@/var_lib_gdm &>/dev/null
btrfs su cr /mnt/@/var_lib_AccountsService &>/dev/null
btrfs su cr /mnt/@/cryptkey &>/dev/null

chattr +C /mnt/@/boot
chattr +C /mnt/@/srv
chattr +C /mnt/@/var_log
chattr +C /mnt/@/var_log_journal
chattr +C /mnt/@/var_crash
chattr +C /mnt/@/var_cache
chattr +C /mnt/@/var_tmp
chattr +C /mnt/@/var_spool
chattr +C /mnt/@/var_lib_libvirt_images
chattr +C /mnt/@/var_lib_machines
chattr +C /mnt/@/var_lib_gdm
chattr +C /mnt/@/var_lib_AccountsService
chattr +C /mnt/@/cryptkey

#Set the default BTRFS Subvol to Snapshot 1 before pacstrapping
btrfs subvolume set-default "$(btrfs subvolume list /mnt | grep "@/.snapshots/1/snapshot" | grep -oP '(?<=ID )[0-9]+')" /mnt

cat << EOF >> /mnt/@/.snapshots/1/info.xml
<?xml version="1.0"?>
<snapshot>
  <type>single</type>
  <num>1</num>
  <date>1999-03-31 0:00:00</date>
  <description>First Root Filesystem</description>
  <cleanup>number</cleanup>
</snapshot>
EOF

chmod 600 /mnt/@/.snapshots/1/info.xml

# Mounting the newly created subvolumes.
umount /mnt
echo "Mounting the newly created subvolumes."
mount -o ssd,noatime,space_cache,compress=zstd:15 $BTRFS /mnt
mkdir -p /mnt/{boot,root,home,.snapshots,srv,tmp,/var/log,/var/crash,/var/cache,/var/tmp,/var/spool,/var/lib/libvirt/images,/var/lib/machines,/var/lib/gdm,/var/lib/AccountsService,/cryptkey}
mount -o ssd,noatime,space_cache=v2,autodefrag,compress=zstd:15,discard=async,nodev,nosuid,noexec,subvol=@/boot $BTRFS /mnt/boot
mount -o ssd,noatime,space_cache=v2,autodefrag,compress=zstd:15,discard=async,nodev,nosuid,subvol=@/root $BTRFS /mnt/root
mount -o ssd,noatime,space_cache=v2,autodefrag,compress=zstd:15,discard=async,nodev,nosuid,subvol=@/home $BTRFS /mnt/home
mount -o ssd,noatime,space_cache=v2,autodefrag,compress=zstd:15,discard=async,subvol=@/.snapshots $BTRFS /mnt/.snapshots
mount -o ssd,noatime,space_cache=v2.autodefrag,compress=zstd:15,discard=async,subvol=@/srv $BTRFS /mnt/srv
mount -o ssd,noatime,space_cache=v2,autodefrag,compress=zstd:15,discard=async,nodatacow,nodev,nosuid,noexec,subvol=@/var_log $BTRFS /mnt/var/log

# Toolbox (https://github.com/containers/toolbox) needs /var/log/journal to have dev, suid, and exec, Thus I am splitting the subvolume. Need to make the directory after /mnt/var/log/ has been mounted.
mkdir -p /mnt/var/log/journal
mount -o ssd,noatime,space_cache=v2,autodefrag,compress=zstd:15,discard=async,nodatacow,subvol=@/var_log_journal $BTRFS /mnt/var/log/journal

mount -o ssd,noatime,space_cache=v2,autodefrag,compress=zstd:15,discard=async,nodatacow,nodev,nosuid,noexec,subvol=@/var_crash $BTRFS /mnt/var/crash
mount -o ssd,noatime,space_cache=v2,autodefrag,compress=zstd:15,discard=async,nodatacow,nodev,nosuid,noexec,subvol=@/var_cache $BTRFS /mnt/var/cache
mount -o ssd,noatime,space_cache=v2,autodefrag,compress=zstd:15,discard=async,nodatacow,nodev,nosuid,noexec,subvol=@/var_tmp $BTRFS /mnt/var/tmp

mount -o ssd,noatime,space_cache=v2,autodefrag,compress=zstd:15,discard=async,nodatacow,nodev,nosuid,noexec,subvol=@/var_spool $BTRFS /mnt/var/spool
mount -o ssd,noatime,space_cache=v2,autodefrag,compress=zstd:15,discard=async,nodatacow,nodev,nosuid,noexec,subvol=@/var_lib_libvirt_images $BTRFS /mnt/var/lib/libvirt/images
mount -o ssd,noatime,space_cache=v2,autodefrag,compress=zstd:15,discard=async,nodatacow,nodev,nosuid,noexec,subvol=@/var_lib_machines $BTRFS /mnt/var/lib/machines

# The encryption is splitted as we do not want to include it in the backup with snap-pac.
mount -o ssd,noatime,space_cache=v2,autodefrag,compress=zstd:15,discard=async,nodatacow,nodev,nosuid,noexec,subvol=@/cryptkey $BTRFS /mnt/cryptkey

mkdir -p /mnt/boot/efi
mount -o nodev,nosuid,noexec $ESP /mnt/boot/efi

# Pacstrap (setting up a base sytem onto the new root).
# As I said above, I am considering replacing gnome-software with pamac-flatpak-gnome as PackageKit seems very buggy on Arch Linux right now.
echo "Installing the base system (it may take a while)."
pacstrap /mnt base ${kernel} ${microcode} linux-firmware grub grub-btrfs snapper snap-pac efibootmgr sudo networkmanager apparmor firewalld zram-generator reflector chrony sbctl openssh fwupd

# Generating /etc/fstab.
echo "Generating a new fstab."
genfstab -U /mnt >> /mnt/etc/fstab
sed -i 's#,subvolid=258,subvol=/@/.snapshots/1/snapshot,subvol=@/.snapshots/1/snapshot##g' /mnt/etc/fstab

# Setting hostname.
read -r -p "Please enter the hostname: " hostname
echo "$hostname" > /mnt/etc/hostname

# Setting hosts file.
echo "Setting hosts file."
cat > /mnt/etc/hosts <<EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   $hostname.localdomain   $hostname
EOF

# Setting up locales.
echo "$locale.UTF-8 UTF-8"  > /mnt/etc/locale.gen
echo "LANG=$locale.UTF-8" > /mnt/etc/locale.conf

# Setting up keyboard layout.
read -r -p "Please insert the keyboard layout you use: " kblayout
echo "KEYMAP=$kblayout" > /mnt/etc/vconsole.conf

# Configuring /etc/mkinitcpio.conf
echo "Configuring /etc/mkinitcpio for ZSTD compression and LUKS hook."
sed -i 's,#COMPRESSION="zstd",COMPRESSION="zstd",g' /mnt/etc/mkinitcpio.conf
sed -i 's,modconf block filesystems keyboard,keyboard modconf block encrypt filesystems,g' /mnt/etc/mkinitcpio.conf

# Enabling LUKS in GRUB and setting the UUID of the LUKS container.
UUID=$(blkid $cryptroot | awk '{print $2}' | sed 's/"//g')
sed -i 's/#\(GRUB_ENABLE_CRYPTODISK=y\)/\1/' /mnt/etc/default/grub
sed -i '$ a\GRUB_BTRFS_OVERRIDE_BOOT_PARTITION_DETECTION=true' /mnt/etc/default/grub
sed -i 's#rootflags=subvol=${rootsubvol}##g' /mnt/etc/grub.d/10_linux
sed -i 's#rootflags=subvol=${rootsubvol}##g' /mnt/etc/grub.d/20_linux_xen

# Enabling CPU Mitigations
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/default/grub.d/40_cpu_mitigations.cfg -o /mnt/etc/grub.d/40_cpu_mitigations.cfg

# Distrusting the CPU
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/default/grub.d/40_distrust_cpu.cfg -o /mnt/etc/grub.d/40_distrust_cpu.cfg

# Enabling IOMMU
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/default/grub.d/40_enable_iommu.cfg -o /mnt/etc/grub.d/40_enable_iommu.cfg

# Enabling NTS
curl https://raw.githubusercontent.com/GrapheneOS/infrastructure/main/chrony.conf -o /mnt/etc/chrony.conf

# Setting GRUB configuration file permissions
chmod 755 /mnt/etc/grub.d/*

# Adding keyfile to the initramfs to avoid double password.
dd bs=512 count=4 if=/dev/random of=/mnt/cryptkey/.root.key iflag=fullblock &>/dev/null
chmod 000 /mnt/cryptkey/.root.key &>/dev/null
cryptsetup -v luksAddKey /dev/disk/by-partlabel/cryptroot /mnt/cryptkey/.root.key
sed -i "s#quiet#cryptdevice=UUID=$UUID:cryptroot root=$BTRFS lsm=landlock,lockdown,yama,apparmor,bpf cryptkey=rootfs:/cryptkey/.root.key#g" /mnt/etc/default/grub
sed -i 's#FILES=()#FILES=(/cryptkey/.root.key)#g' /mnt/etc/mkinitcpio.conf

# Configure AppArmor Parser caching
sed -i 's/#write-cache/write-cache/g' /mnt/etc/apparmor/parser.conf
sed -i 's,#Include /etc/apparmor.d/,Include /etc/apparmor.d/,g' /mnt/etc/apparmor/parser.conf

# Blacklisting kernel modules
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/modprobe.d/30_security-misc.conf -o /mnt/etc/modprobe.d/30_security-misc.conf
chmod 600 /mnt/etc/modprobe.d/*

# Security kernel settings.
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/usr/lib/sysctl.d/990-security-misc.conf -o /mnt/etc/sysctl.d/990-security-misc.conf
sed -i 's/kernel.yama.ptrace_scope=2/kernel.yama.ptrace_scope=3/g' /mnt/etc/sysctl.d/990-security-misc.conf
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/sysctl.d/30_silent-kernel-printk.conf -o /mnt/etc/sysctl.d/30_silent-kernel-printk.conf
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/sysctl.d/30_security-misc_kexec-disable.conf -o /mnt/etc/sysctl.d/30_security-misc_kexec-disable.conf
chmod 600 /mnt/etc/sysctl.d/*

# Remove nullok from system-auth
sed -i 's/nullok//g' /mnt/etc/pam.d/system-auth

# Disable coredump
echo "* hard core 0" >> /mnt/etc/security/limits.conf

# Disable su for non-wheel users
bash -c 'cat > /mnt/etc/pam.d/su' <<-'EOF'
#%PAM-1.0
auth		sufficient	pam_rootok.so
# Uncomment the following line to implicitly trust users in the "wheel" group.
#auth		sufficient	pam_wheel.so trust use_uid
# Uncomment the following line to require a user to be in the "wheel" group.
auth		required	pam_wheel.so use_uid
auth		required	pam_unix.so
account		required	pam_unix.so
session		required	pam_unix.so
EOF

# ZRAM configuration
bash -c 'cat > /mnt/etc/systemd/zram-generator.conf' <<-'EOF'
[zram0]
zram-fraction = 1
max-zram-size = 8192
EOF

# Configuring the system.
arch-chroot /mnt /bin/bash -e <<EOF

    # Setting up timezone.
    ln -sf /usr/share/zoneinfo/$(curl -s http://ip-api.com/line?fields=timezone) /etc/localtime &>/dev/null

    # Setting up clock.
    hwclock --systohc

    # Generating locales.my keys aren't even on
    echo "Generating locales."
    locale-gen &>/dev/null

    # Generating a new initramfs.
    echo "Creating a new initramfs."
    chmod 600 /boot/initramfs-linux* &>/dev/null
    mkinitcpio -P &>/dev/null

    # Snapper configuration
    umount /.snapshots
    rm -r /.snapshots
    snapper --no-dbus -c root create-config /
    btrfs subvolume delete /.snapshots
    mkdir /.snapshots
    mount -a
    chmod 750 /.snapshots

    # Installing GRUB.
    echo "Installing GRUB on /boot."
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --modules="normal test efi_gop efi_uga search echo linux all_video gfxmenu gfxterm_background gfxterm_menu gfxterm loadenv configfile gzio part_gpt cryptodisk luks gcry_rijndael gcry_sha256 btrfs" --disable-shim-lock &>/dev/null

    # Creating grub config file.
    echo "Creating GRUB config file."
    grub-mkconfig -o /boot/grub/grub.cfg &>/dev/null
    sed -i 's#\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)"#\1 cryptdevice=UUID='"$UUID"':cryptroot root='"$BTRFS"' lsm=landlock,lockdown,yama,apparmor,bpf cryptkey=rootfs:/cryptkey/.root.key"#' /mnt/etc/default/grub

    # Adding user with sudo privilege
    if [ -n "$username" ]; then
        echo "Adding $username with root privilege."
        useradd -m $username
        usermod -aG wheel $username

        groupadd -r audit
        gpasswd -a $username audit
    fi
EOF

# Setting user password.
[ -n "$username" ] && echo "Setting user password for ${username}." && echo -e "${password}\n${password}" | arch-chroot /mnt passwd "$username" &>/dev/null

# Giving wheel user sudo access.
sed -i 's/# \(%wheel ALL=(ALL\(:ALL\|\)) ALL\)/\1/g' /mnt/etc/sudoers

# Change audit logging group
echo "log_group = audit" >> /mnt/etc/audit/auditd.conf

# Enabling audit service.
systemctl enable auditd --root=/mnt &>/dev/null

# Enabling openssh server
systemctl enable sshd --root=/mnt &>/dev/null

# Enabling auto-trimming service.
systemctl enable fstrim.timer --root=/mnt &>/dev/null

# Enabling NetworkManager.
systemctl enable NetworkManager --root=/mnt &>/dev/null

# Enabling AppArmor.
echo "Enabling AppArmor."
systemctl enable apparmor --root=/mnt &>/dev/null

# Enabling Firewalld.
echo "Enabling Firewalld."
systemctl enable firewalld --root=/mnt &>/dev/null

# Enabling Reflector timer.
echo "Enabling Reflector."
systemctl enable reflector.timer --root=/mnt &>/dev/null

# Enabling systemd-oomd.
echo "Enabling systemd-oomd."
systemctl enable systemd-oomd --root=/mnt &>/dev/null

# Disabling systemd-timesyncd
systemctl disable systemd-timesyncd --root=/mnt &>/dev/null

# Enabling chronyd
systemctl enable chronyd --root=/mnt &>/dev/null

# Enabling Snapper automatic snapshots.
echo "Enabling Snapper and automatic snapshots entries."
systemctl enable snapper-timeline.timer --root=/mnt &>/dev/null
systemctl enable snapper-cleanup.timer --root=/mnt &>/dev/null
systemctl enable grub-btrfs.path --root=/mnt &>/dev/null

# Setting umask to 077.
sed -i 's/022/077/g' /mnt/etc/profile
echo "" >> /mnt/etc/bash.bashrc
echo "umask 077" >> /mnt/etc/bash.bashrc

# Finishing up
echo "Done, you may now wish to reboot (further changes can be done by chrooting into /mnt)."

exit
