<div align = center>

&ensp;[<kbd> <br> Install <br> </kbd>](#Installation)&ensp;
&ensp;[<kbd> <br> Post Install <br> </kbd>](#Post-Installation)&ensp;
&ensp;[<kbd> <br> Keybindings <br> </kbd>](#Keybindings)&ensp;
&ensp;[<kbd> <br> Packages <br> </kbd>](#Packages)&ensp;
&ensp;[<kbd> <br> Themes <br> </kbd>](#Themes)&ensp;
<br><br></div>

## HyprWorldz

Sharing my Arch Linux Development for Hyprland, a project merging the "worldz best" hyprland rice design and features.

Starts with a fork of [hyprdots](https://github.com/prasanthrangan), with some personal changes to theme and custom_pkg.lst has extra packages.

Nvidia modern GPU support from [JaKooLit](https://github.com/JaKooLit/) as been intergrated, auto detects and sets up grub or systemd-boot.

I really like [ML4W](https://gitlab.com/stephan-raabe/dotfiles) and [Gl00ria](https://github.com/Gl00ria/dotfiles/tree/main/dot_hyprland) work, which has design and features which have or maybe added or inspired from.

* Supports Nvidia GPU'S (modern only)
* Nvidia Grub and systemd-boot configs
* Grub Theme and Plymouth Boot Theme (script prompts for theme selection)
* Added "Custom apps" in waybar<br>
* Offical Hyprland Plugins added

Notes: [More Grub Themes](https://github.com/ahmedmoselhi/distro-grub-themes)<br>

**Post Install Setup**
* [SecureBoot](#SecureBoot)

**Todo:** <br>
* Add Flame shot ✔️
* Put Nvidia config into one file (nvidia.sh, cleanup old files) ✔️
* Intergrate VM solution
* Add Custom apps in waybar
* Add "theme change options buttons" to system menu and remove from waybar
* Create a smaller App Launcher theme
* Add Nature theme pack
* Add Spritual theme pack
* Add People theme pack
* Add Animals theme pack
* Create Theme Pack selector
* Does nvidia-prime allow for hybrid graphics?

## Installation

> [!IMPORTANT]
> Install script will auto-detect nvidia card and install nvidia-dkms drivers for your kernel.
> So please ensure that your Nvidia card supports [dkms](https://wiki.archlinux.org/title/NVIDIA) drivers and hyprland.

> [!CAUTION]
> The script modifies your grub or systemd-boot config to enable Nvidia drm and theme.
> This script is also designed to be done after a fresh minimal arch installation ONLY (no desktop installeed).
> If using Secure boot you must select "Unified image" and password protect the bios, this is required.

After a minimal Arch install (with grub and systemd), clone and execute -

```shell
pacman -Sy git
git clone --depth 1 https://github.com/5ouls3dge/hyprWorldz/ ~/HyprWorldz
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

<div align = center>
  
[<kbd> <br> 🡅 <br> </kbd>](#Hyprworld)
</div>

## Post Installation

Guides to install optional Plymouth, Grub Theme, Snapper and Secure Boot. These steps can be followed after installation.

## Plymouth
Install from Aur, you can find repo themes [here](https://aur.archlinux.org/packages?O=0&SeB=nd&K=The+plymouth+theme+collection&outdated=&SB=p&SO=d&PP=50&submit=Go):

```bash
yay -S plymouth plymouth-theme-NAME-git
```

Further source and visual examples from these links:

Download your theme from [here](https://github.com/adi1090x/plymouth-themes).<br>
They are ported from android bootloaders [here](https://xdaforums.com/t/bootanimations-collection.3721978/#post-74901989) where you can view them only.<br>

Example:

```
$ yay -S plymouth plymouth-theme-arch-charge
$ sudo plymouth-set-default-theme arch-charge
```

If you remember from earlier there's an extra `mkinitcpio` hook to be added:

```
HOOKS="base systemd plymouth autodetect keyboard sd-vconsole modconf block sd-encrypt filesystems fsck"
```

Just that extra `plymouth`.

Before rebooting you should also tell `mkinitcpio` that you need to load your graphics module. This will
depend on which card you have. I can only vouch for Intel and NVIDIA. You need to edit the `MODULES`
section of `mkinitcpio.conf`:

```
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)    # for nvidia cards
MODULES=(i915)                                           # for intel cards
```

No, you're not done yet. You need to add yet more kernel options to your `/boot/loader/entries/linux.conf`.
Again, `linux.conf` is the name I picked, you can choose whatever you like. In the `options` line, append:

```
quiet splash loglevel=3 rd.udev.log_priority=3 vt.global_cursor_default=0
```

Once that is done, `mkintcpio -P` will be enough: you can reboot now and you should be able to see the splash
screen on shutdown already.

## SecureBoot

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

<div align = center>
  
[<kbd> <br> 🡅 <br> </kbd>](#Hyprworld)
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

<div align = center>
  
[<kbd> <br> 🡅 <br> </kbd>](#Hyprworld)
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
    <code>s</code><br><code>h</code><br><code>e</code><br><code>l</code><br><code>l</code></td><td><table>
    <tr><td>zsh</td><td>main shell</td></tr>
    <tr><td>eza</td><td>colorful file lister</td></tr>
    <tr><td>oh-my-zsh-git</td><td>for zsh plugins</td></tr>
    <tr><td>zsh-theme-powerlevel10k-git</td><td>theme for zsh</td></tr></table>
</td></tr></table>

<div align = center>
  
[<kbd> <br> 🡅 <br> </kbd>](#Hyprworldz)
</div>


## Themes

To create your own custom theme, please refer [theming wiki](https://github.com/prasanthrangan/hyprdots/wiki/Theming)

> [!TIP]
> You can install/browse/create/maintain/share additional themes (ex. [Synth-Wave](https://github.com/prasanthrangan/hyprdots-mod)) using themepatcher.
> For more details please refer [themepatcher wiki](https://github.com/prasanthrangan/hyprdots/wiki/Themepatcher).


<div align = center>
  
[<kbd> <br> 🡅 <br> </kbd>](#Hyprworld)
</div>
