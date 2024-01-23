&ensp;[<kbd> <br> Install <br> </kbd>](#Installation)&ensp;
&ensp;[<kbd> <br> Post Install <br> </kbd>](#Post-Installation)&ensp;
&ensp;[<kbd> <br> Packages <br> </kbd>](#Packages)&ensp;
&ensp;[<kbd> <br> Keybindings <br> </kbd>](#Keybindings)&ensp;
&ensp;[<kbd> <br> Themes <br> </kbd>](#Themes)&ensp;
&ensp;[<kbd> <br> Styles <br> </kbd>](#Styles)&ensp;
<br><br><br><br></div>

## Installation

> [!IMPORTANT]
> Install script will auto-detect nvidia card and install nvidia-dkms drivers for your kernel.
> So please ensure that your Nvidia card supports [dkms](https://wiki.archlinux.org/title/NVIDIA) drivers and hyprland.

> [!CAUTION]
> The script modifies your grub config to enable Nvidia drm and theme.
> This script is also designed to be done after a minimal arch installation, using it on previously installed desktop should work but will change whatever you currently have (gtk/qt theming, shell, sddm, grub, etc) and is at your own risk.

After a minimal Arch install (with grub and systemd), clone and execute -

```shell
pacman -Sy git
git clone --depth 1 https://github.com/dewaltz/hyprworld ~/Hyprworld
cd ~/Hyprdots/Scripts
./install.sh
```

> [!TIP]
> You can also create your own list (for ex. `custom_apps.lst`) with all your favorite apps and pass the file as a parameter to install it -
>```shell
>./install.sh custom_apps.lst
>```

Please reboot after the install script completes and takes you to sddm login screen (or black screen) for the first time.
For more details, please refer [installation wiki](https://github.com/prasanthrangan/hyprdots/wiki/Installation)

### Updating
To update Hyprdots you will need to pull the latest changes from github and restore the configs by doing -

```shell
cd ~/Hyprdots/Scripts
git pull
./install.sh -r
```

> [!IMPORTANT]
> This backs up and overwrites all configs as setup by `restore_cfg.lst` in ~/Hyprdots/Scripts.
> So please note that any configurations you made may be overwritten if listed to be done so, but can be recovered in ~/.config/cfg_backups.

[<kbd> <br> 🡅 <br> </kbd>](#-design-by-t2)

## Post Installation

Guide to install Plymouth and Secure Boot

## Boot loader and `mkinitcpio`

Alright: this is where you can't fuck stuff up. If you fuck stuff up here your system
won't boot. Typically when this happens it's recoverable from the install medium you
used, via `arch-chroot` and so on. With encrypted setups doing this is annoying because
on every reboot with the install medium you always need to open the volume, mount the
root partition and so on, so every fuckup adds minutes to the debugging process. To
add insult to injury, debugging is often hard because the messages aren't very helpful.
<br>
Having said that, here we go.
<br>
What I'd do first is check [the guide](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system).
<br>
This is what my `/etc/mkinitcpio.conf` with looks.like:
<br>
```
HOOKS="base systemd plymouth autodetect keyboard sd-vconsole modconf block sd-encrypt filesystems resume fsck
```
<br>
The order of stuff is very important here so even though you might not find some things yet
(e.g. `plymouth` certainly isn't there).
<br>
If you don't have `sd`-related things don't panic, we haven't added those yet. We'll do that in
a second.
<br>
Now it's a good time to run your first `mkinitcpio`:
<br><br>
```
mkinitcpio -P
```
<br><br>
Chances are that this has been run already by several of the commands we ran earlier.
<br>
We'll use `systemd-boot`. A few principles:
<br>
* It will be installed in your EFI partition.
* It will grab loader entries from `/boot/loader/entries/` so once it's installed we'll make
  sure you have a valid one there.
  <br>
Install it:
<br><br>
```
# bootctl install
```
<br><br>
There are ways to keep it updated. Either you just run `bootctl update` every now and then or
[add a hook so that it's done automatically](https://wiki.archlinux.org/index.php/Systemd-boot#Automatic_update)
(this isn't a hard requirement).
<br>
The crucial thing is to get **one** working entry. Check out the contents of `/boot/loader/entries`, there
might be something there already. Just in case, here's what a working entry looks like:
<br>
```
title Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options rd.luks.name=[PLACEHOLDER_1]=[PLACEHOLDER_2] root=[PLACEHOLDER_3] rw
```
<br>
Trivial things first: if you have an Intel CPU you should install the `intel-ucode` package and keep that
line, otherwise if you have an AMD CPU you should install the `amd-ucode` package and replace `intel-ucode.img`
with `amd-ucode.img`.
<br>
Now with the three placeholders. We need to rewind a bit and do some matching. The third placeholder is the
easy one: this is the root partition's "device", the "thing that you mount". So `/dev/mapper/main` or
whatever you decided to `cryptsetup open`.
<br>
Let's run `blkid`:
<br><br>
```
# blkid
/dev/nvme0n1p1: UUID="284C-3A64" BLOCK_SIZE="512" TYPE="vfat" PARTUUID="0794ef09-5eb8-d144-b103-bc7b975f8963"
/dev/nvme0n1p2: UUID="79ac497a-7eac-4f16-af63-f362c52ed44c" TYPE="crypto_LUKS" PARTUUID="58319ad0-043c-fc48-9c4b-c466484d1135"
/dev/mapper/main: UUID="fd884ff1-12a0-4289-89ce-11ca73f4af89" BLOCK_SIZE="4096" TYPE="ext4"
```
<br><br>
The first and second placeholder are, respectively, the UUID of the **outermost** layer of the partitions
onion:
<br><br>
```
options rd.luks.name=79ac497a-7eac-4f16-af63-f362c52ed44c=main root=/dev/mapper/main
```
<br><br>
Triple check that you're not using the UUID of `/dev/mapper/main`. If you do that, your computer won't boot.
<br>
`main` is the name of whatever you picked earlier with cryptsetup: unclear if there needs to be consistency
(there probably has to), so remember the general idea and keep tabs.
<br>
**Save your new entry** as `/boot/loader/entries/linux.conf`. It should be fine to keep that as your only
entry.
<br>
Now back to `/etc/mkinitcpio.conf`, check out the `HOOKS` line again:
<br><br>
```
HOOKS="base systemd autodetect keyboard sd-vconsole modconf block sd-encrypt filesystems resume fsck"
```
<br><br>
To be safe, run `mkinitcpio -P` again (no use not doing so).
<br>
Now you can reboot and cross your fingers.
<br>
## I have rebooted and it doesn't work
<br>
If you see `systemd-boot`'s prompt (i.e. you see a `Linux` entry) but then booting hangs the mistake
should be almost certainly because you messed up ID's and names. Don't despair, it's fixable without
having to start from scratch. Boot from the install medium and mount the root and boot partitions.
<br>
1. Check `mkinitcpio.conf` just in case, compare with the `HOOKS` above.<br>
2. Check the UUID's in `/boot/loader/entries/linux.conf` (or whichever the UUIDs).<br>
<br>
Fixing these mistakes is very annoying because each reboot is time consuming.<br>

## I have rebooted and it works
<br>
Well done, there isn't much left to do.
<br>
From here on I'll take a few things for granted, like that GNOME works and that your main
user can `sudo` (and of course that `sudo` is installed), etc.
<br>
## Plymouth
<br>
For some strange reason, `plymouth` hasn't made it out of the AUR. This is a good opportunity to
install an AUR helper, i.e. a piece of software that handles installation from the AUR automatically.
I recommend `yay` but you might have a different opinion. Have a look
[here](https://github.com/Jguer/yay) on how to install it.
<br><br>
```
$ yay -S plymouth plymouth-theme-arch-charge
$ sudo plymouth-set-default-theme arch-charge
```<br><br>

If you remember from earlier there's an extra `mkinitcpio` hook to be added:
<br><br>
```
HOOKS="base systemd plymouth autodetect keyboard sd-vconsole modconf block sd-encrypt filesystems fsck"
```
<br><br>
Just that extra `plymouth`.
<br>
Before rebooting you should also tell `mkinitcpio` that you need to load your graphics module. This will
depend on which card you have. I can only vouch for Intel and NVIDIA. You need to edit the `MODULES`
section of `mkinitcpio.conf`:
<br>
```
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)    # for nvidia cards
MODULES=(i915)                                           # for intel cards
```
<br>
No, you're not done yet. You need to add yet more kernel options to your `/boot/loader/entries/linux.conf`.
Again, `linux.conf` is the name I picked, you can choose whatever you like. In the `options` line, append:
<br>
```
quiet splash loglevel=3 rd.udev.log_priority=3 vt.global_cursor_default=0
```
<br>
Once that is done, `mkintcpio -P` will be enough: you can reboot now and you should be able to see the splash
screen on shutdown already.
<br>
## Secure boot
<br>
Briefly, secure boot is a feature that only allows to boot signed files. If a file isn't signed the bootloader
rejects it. The keys are stored in a module in your computer that only the BIOS can access, and, of course
within your hard drive (or wherever else you want to store them, concretely).

In order for this to be secure, you must do the following:

1. Secure boot must be enforced
2. Your BIOS must be protected with a password
3. The partition containing your keys must be encrypted

If 1. isn't true, someone could replace your signed kernel with a malicious one that you will boot without
knowing. If 2. isn't true, someone could access your bios, disable secure boot, and you're back to point 1.
If 3. isn't true, someone could sign a malicious kernel with your keys, without the need to tamper with
the BIOS.

Another requirement is to use [UKIs](https://wiki.archlinux.org/title/Unified_kernel_image) that replace
the old initrd/vmlinuz combo, plus the boot parameters.

Reminder of our bootloader entry:

```
title Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options rd.luks.name=[PLACEHOLDER_1]=[PLACEHOLDER_2] root=[PLACEHOLDER_3] rw
```

It will become like this:

```
title Linux
efi /EFI/arch/linux-signed.efi
```

The microcode and initramfs part will go into `/etc/mkinicpio.d/linux.preset`

```
ALL_kver="/boot/vmlinuz-linux"
ALL_microcode=(/boot/*-ucode.img)

PRESETS=('default')

default_image="/boot/initramfs-linux.img"
default_uki="/boot/EFI/arch/linux-signed.efi"
```

As you can see `default_uki` is the thing that is referenced in `/boot/loader/entries/linux.conf`.

The other part, the kernel boot parameters can go into two different places, `/etc/cmdline.d/*.conf`
or `/etc/kernel/cmdline`. I chose the latter but it's the same. Edit the file and put 

```
rd.luks.name=[PLACEHOLDER_1]=[PLACEHOLDER_2] root=[PLACEHOLDER_3] rw  # and all the other params
```

Basically the last line of the old bootloader entry minus `options`.

If you now run `mkinitcpio -P` you should see `/boot/EFI/arch/linux-signed.efi`.

To then configure secure boot there are two options. One is manual but it gives you a bit more
control (but it is clunky). The other one is way easier, and it involves `sbctl` (which you
need to install).

I will detail the essential procedure, as **instructions are not universal**.

* Create keys with `sbctl create-keys`.
* Try `sbctl enroll-keys -m -f`. This command puts your newly created keys plus the Microsoft
  ones **and** the ones recommended by the firmware, into the BIOS. Chances are that it
  might fail because you need to be in "setup mode". This, in some cases, requires wiping
  the secure boot configuration, and with it the pre-enrolled keys. Check around if
  your computer needs them urgently to boot (it probably doesn't). If it doesn't, reboot
  into the BIOS, put your computer in setup mode (in the Framework Laptop case this is
  achieved by erasing all secure boot settings), then re-run the command again. If it
  succeeds, move on. If it fails, you'll need to dig more.
* Run `sbctl verify` and you'll have a list of files that you need to sign. Typically
  the bootloader (`/boot/EFI/BOOT/BOOTX64.EFI`) and the kernel UKI
  (`/boot/EFI/arch/linux-signed.efi`).
* Sign all of them with `sbctl sign -s` (don't forget `-s` as it saves the path to the
  database so that every kernel/systemd upgrade will trigger a signature.
* Run `sbctl status` and `sbctl verify` and check that everything makes sense.
* Reboot and enable secure boot.

[<kbd> <br> 🡅 <br> </kbd>](#-design-by-t2)
</div>

## Packages

<table><tr><td>
<code>n</code><br><code>v</code><br><code>i</code><br><code>d</code><br><code>i</code><br><code>a</code></td><td><table>
    <tr><td>linux-headers</td><td>for main kernel (script will auto detect from /usr/lib/modules/)</td></tr>
    <tr><td>linux-zen-headers</td><td>for zen kernel (script will auto detect from /usr/lib/modules/)</td></tr>
    <tr><td>linux-lts-headers</td><td>for lts kernel (script will auto detect from /usr/lib/modules/)</td></tr>
    <tr><td>nvidia-dkms</td><td>nvidia drivers (script will auto detect from lspci -k | grep -A 2 -E "(VGA|3D)")</td></tr>
    <tr><td>nvidia-utils</td><td>nvidia utils (script will auto detect from lspci -k | grep -A 2 -E "(VGA|3D)")</td></tr></table>
</td></tr></table>

<table><tr><td>
<code>u</code><br><code>t</code><br><code>i</code><br><code>l</code><br><code>s</code></td><td><table>
    <tr><td>pipewire</td><td>audio and video server</td></tr>
    <tr><td>pipewire-alsa</td><td>for audio</td></tr>
    <tr><td>pipewire-audio</td><td>for audio</td></tr>
    <tr><td>pipewire-jack</td><td>for audio</td></tr>
    <tr><td>pipewire-pulse</td><td>for audio</td></tr>
    <tr><td>gst-plugin-pipewire</td><td>for audio</td></tr>
    <tr><td>wireplumber</td><td>audio and video server</td></tr>
    <tr><td>networkmanager</td><td>network manager</td></tr>
    <tr><td>network-manager-applet</td><td>nm tray</td></tr>
    <tr><td>bluez</td><td>for bluetooth</td></tr>
    <tr><td>bluez-utils</td><td>for bluetooth</td></tr>
    <tr><td>blueman</td><td>bt tray</td></tr></table>
</td></tr></table>

<table><tr><td>
<code>l</code><br><code>o</code><br><code>g</code><br><code>i</code><br><code>n</code></td><td><table>
    <tr><td>sddm-git</td><td>display manager for login</td></tr>
    <tr><td>qt5-wayland</td><td>for QT wayland XDP</td></tr>
    <tr><td>qt6-wayland</td><td>for QT wayland XDP</td></tr>
    <tr><td>qt5-quickcontrols</td><td>for sddm theme</td></tr>
    <tr><td>qt5-quickcontrols2</td><td>for sddm theme</td></tr>
    <tr><td>qt5-graphicaleffects</td><td>for sddm theme</td></tr></table>
</td></tr></table>

<table><tr><td>
<code>h</code><br><code>y</code><br><code>p</code><br><code>r</code></td><td><table>
    <tr><td>hyprland-git</td><td>main window manager (hyprland-nvidia-git if nvidia card is detected)</td></tr>
    <tr><td>dunst</td><td>graphical notification daemon</td></tr>
    <tr><td>rofi-lbonn-wayland-git</td><td>app launcher</td></tr>
    <tr><td>waybar-hyprland-git</td><td>status bar</td></tr>
    <tr><td>swww</td><td>wallpaper app</td></tr>
    <tr><td>swaylock-effects-git</td><td>lockscreen</td></tr>
    <tr><td>wlogout</td><td>logout screen</td></tr>
    <tr><td>grimblast-git</td><td>screenshot tool</td></tr>
    <tr><td>slurp</td><td>selects region for screenshot/screenshare</td></tr>
    <tr><td>swappy</td><td>screenshot editor</td></tr>
    <tr><td>cliphist</td><td>clipboard manager</td></tr></table>
</td></tr></table>

<table><tr><td>
<code>d</code><br><code>e</code><br><code>p</code><br><code>e</code><br><code>n</code><br><code>d</code><br><code>e</code><br><code>n</code><br><code>c</code><br><code>y</code></td><td><table>
    <tr><td>polkit-kde-agent</td><td>authentication agent</td></tr>
    <tr><td>xdg-desktop-portal-hyprland</td><td>XDG Desktop Portal</td></tr>
    <tr><td>pacman-contrib</td><td>for system update check</td></tr>
    <tr><td>python-pyamdgpuinfo</td><td>for amd gpu info</td></tr>
    <tr><td>parallel</td><td>for parallel processing</td></tr>
    <tr><td>jq</td><td>to read json</td></tr>
    <tr><td>imagemagick</td><td>for image processing</td></tr>
    <tr><td>qt5-imageformats</td><td>for dolphin image thumbnails</td></tr>
    <tr><td>ffmpegthumbs</td><td>for dolphin video thumbnails</td></tr>
    <tr><td>kde-cli-tools</td><td>for dolphin open with option</td></tr>
    <tr><td>brightnessctl</td><td>brightness control for laptop</td></tr>
    <tr><td>pavucontrol</td><td>audio settings gui</td></tr>
    <tr><td>pamixer</td><td>for waybar audio</td></tr></table>
</td></tr></table>

<table><tr><td>
<code>t</code><br><code>h</code><br><code>e</code><br><code>m</code><br><code>e</code></td><td><table>
    <tr><td>nwg-look</td><td>theming GTK apps</td></tr>
    <tr><td>kvantum</td><td>theming QT apps</td></tr>
    <tr><td>qt5ct</td><td>theming QT5 apps</td></tr></table>
</td></tr></table>

<table><tr><td>
<code>a</code><br><code>p</code><br><code>p</code><br><code>s</code></td><td><table>
    <tr><td>firefox</td><td>browser</td></tr>
    <tr><td>kitty</td><td>terminal</td></tr>
    <tr><td>neofetch</td><td>fetch tool</td></tr>
    <tr><td>dolphin</td><td>kde file manager</td></tr>
    <tr><td>visual-studio-code-bin</td><td>gui code editor</td></tr>
    <tr><td>vim</td><td>text editor</td></tr>
    <tr><td>ark</td><td>kde file archiver</td></tr></table>
</td></tr></table>

<table><tr><td>
    <code>s</code><br><code>h</code><br><code>e</code><br><code>l</code><br><code>l</code></td><td><table>
    <tr><td>zsh</td><td>main shell</td></tr>
    <tr><td>eza</td><td>colorful file lister</td></tr>
    <tr><td>oh-my-zsh-git</td><td>for zsh plugins</td></tr>
    <tr><td>zsh-theme-powerlevel10k-git</td><td>theme for zsh</td></tr>
    <tr><td>pokemon-colorscripts-git</td><td>display pokemon sprites</td></tr></table>
</td></tr></table>

<div align = right> <br><br>
[<kbd> <br> 🡅 <br> </kbd>](#-design-by-t2)
</div>

## Keybindings

| Keys | Action |
| :--  | :-- |
| <kbd>Super</kbd> + <kbd>Q</kbd> | quit active/focused window
| <kbd>Alt</kbd> + <kbd>F4</kbd> | quit active/focused window
| <kbd>Super</kbd> + <kbd>Del</kbd> | quit hyprland session
| <kbd>Super</kbd> + <kbd>W</kbd> | toggle window on focus to float
| <kbd>Alt</kbd> + <kbd>Enter</kbd> | toggle window on focus to fullscreen
| <kbd>Super</kbd> + <kbd>J</kbd> | toggle layout
| <kbd>Super</kbd> + <kbd>G</kbd> | toggle window group
| <kbd>Super</kbd> + <kbd>T</kbd> | launch kitty terminal
| <kbd>Super</kbd> + <kbd>E</kbd> | launch dolphin file explorer
| <kbd>Super</kbd> + <kbd>C</kbd> | launch vscode
| <kbd>Super</kbd> + <kbd>F</kbd> | launch firefox
| <kbd>Super</kbd> + <kbd>A</kbd> | launch desktop applications (rofi)
| <kbd>Super</kbd> + <kbd>Tab</kbd> | switch open applications (rofi)
| <kbd>Super</kbd> + <kbd>R</kbd> | browse system files (rofi)
| <kbd>F10</kbd> | mute audio output (toggle)
| <kbd>F11</kbd> | decrease volume (hold)
| <kbd>F12</kbd> | increase volume (hold)
| <kbd>Super</kbd> + <kbd>V</kbd> | clipboard history paste
| <kbd>Super</kbd> + <kbd>L</kbd> | lock screen
| <kbd>Super</kbd> + <kbd>Backspace</kbd> | logout menu
| <kbd>Super</kbd> + <kbd>K</kbd> | switch keyboard layout
| <kbd>Super</kbd> + <kbd>P</kbd> | drag to select area or click on a window to print
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>P</kbd> | print current screen
| <kbd>Super</kbd> + <kbd>Ctrl</kbd> + <kbd>P</kbd> | print current screen (frozen)
| <kbd>Super</kbd> + <kbd>RightClick</kbd> | resize the window
| <kbd>Super</kbd> + <kbd>LeftClick</kbd> | change the window position
| <kbd>Super</kbd> + <kbd>MouseScroll</kbd> | cycle through workspaces
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>←</kbd><kbd>→</kbd><kbd>↑</kbd><kbd>↓</kbd>| resize windows (hold)
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>Ctrl</kbd> + <kbd>←</kbd><kbd>→</kbd><kbd>↑</kbd><kbd>↓</kbd>| move active window within the current workspace
| <kbd>Super</kbd> + <kbd>[0-9]</kbd> | switch to workspace [0-9]
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>[0-9]</kbd> | move active window to workspace [0-9]
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>[0-9]</kbd> | move active window to workspace [0-9] (silently)
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>S</kbd> | move window to special workspace
| <kbd>Super</kbd> + <kbd>S</kbd> | toogle to special workspace
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>G</kbd> | disable hypr effects for gamemode
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>→</kbd> | next wallpaper
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>←</kbd> | previous wallpaper
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>↑</kbd> | next waybar mode
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>↓</kbd> | previous waybar mode
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>D</kbd> | toggle (theme <//> wall) based colors
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>T</kbd> | theme select menu
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>W</kbd> | wallpaper select menu
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>A</kbd> | rofi style select menu


<div align = right> <br><br>

[<kbd> <br> 🡅 <br> </kbd>](#-design-by-t2)
</div>


## Themes

To create your own custom theme, please refer [theming wiki](https://github.com/prasanthrangan/hyprdots/wiki/Theming)

> [!TIP]
> You can install/browse/create/maintain/share additional themes (ex. [Synth-Wave](https://github.com/prasanthrangan/hyprdots-mod)) using themepatcher.
> For more details please refer [themepatcher wiki](https://github.com/prasanthrangan/hyprdots/wiki/Themepatcher).

## Styles

| Theme Select |
| :-: |
| ![Theme Select](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_select.png) |

| Wallpaper Select |
| :-: |
| ![Wallpaper Select](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/walls_select.png) |

| Launcher Style Select |
| :-: |
| ![Launcher Style Select](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_sel.png) |

| Launcher Styles |
| :-: |
| ![rofi style#1](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_1.png) |
| ![rofi style#2](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_2.png) |
| ![rofi style#3](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_3.png) |
| ![rofi style#4](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_4.png) |
| ![rofi style#5](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_5.png) |
| ![rofi style#6](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_6.png) |
| ![rofi style#7](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_7.png) |
| ![rofi style#8](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_8.png) |

| Wlogout Menu |
| :-: |
| ![Wlogout Menu#1](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/wlog_style_1.png) |
| ![Wlogout Menu#2](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/wlog_style_2.png) |

| Game Launchers |
| :-: |
| ![Game Launchers#1](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/game_launch_1.png) |
| ![Game Launchers#2](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/game_launch_2.png) |
| ![Game Launchers#3](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/game_launch_3.png) |
| ![Game Launchers#4](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/game_launch_4.png) |
| ![Game Launchers#5](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/game_launch_5.png) |


<div align = right> <br><br>
[<kbd> <br> 🡅 <br> </kbd>](#-design-by-t2)
</div>
