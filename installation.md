# --// Hyprdots Installation //--

<p align="center">
  <img width="100" src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/hyprdots_logo.png">
</p>


## Process

The install script has 3 main sections
- [i]nstall
    - prepare temp list of packages `install_pkg.lst` from main package list `custom_hypr.lst`
    - if the user pass additional list `custom_apps.lst`, then add it to the list `install_pkg.lst`
    - if nvidia card is detected in system, add `nvidia-dkms` and `nvidia-utils` to the list `install_pkg.lst`
        - script also works for AMD and Intel system, it will just skip this nvidia packages.
    - install packages from `install_pkg.lst`
        - use `pacman` to install package if its available in official arch repo
        - use `yay` to install package if its available in AUR

- [d]efault
    - exactly same as install, but with `--noconfirm` option
    - will skip user input and use default option(s) to install, but prompts sudo password when required

- [r]estore
    - uncompress `tar.gz` files from `Source/arcs/` to the target location specified in [restore_fnt.lst](#restoring-archives)
    - backup existing config files to `$HOME/.config/cfg_YYMMDD_HHhMMmSSs` directory.
    - copy dot files from `Configs` directory to corresponding target location specified in [restore_cfg.lst](#restoring-configs) for installed packages
    - fix/update all the symlinks used

- [s]ervice
    - enable and start system services like sddm and bluetooth


### Restoring Archives

Archive (tar.gz) files are restored/extracted based on `restore_fnt.lst`, a `|` delimited control file structured as,
```shell
<archive_name>|<target_path>
```
where column,
1. is a compressed tar.gz file named `<archive_name>.tar.gz`, should be located in `Source/arcs/<archive_name>.tar.gz`
2. is the target location to extract


### Restoring Configs

Config/dot files are restored based on `restore_cfg.lst`, a `|` delimited control file structured as,
```shell
<target_path>|<dir_or_file_name1> <dir_or_file_name2>|<package_name1> <package_name2>
```
where column,
1. is the target location to copy
2. is the file or directory list separated by space to copy from `Configs/` directory. Here all files in `Configs/` should follow the same structure as its target directory (col 1).
3. is the package(s) names separated by space to check dependency, so if the package(s) is not installed it will not copy its corresponding config file(s)


## Flow

![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/install_flow.png)


## Execution

The install script can be executed in different modes,

- for default full hyprland installation with all configs
```shell
./install.sh
```

- for full or minimal hyprland installation + your favorite packages (ex. `custom_apps.lst`) 
```shell
./install.sh custom_apps.lst # full install custom_hypr.lst + custom_app.lst with configs
./install.sh -i custom_apps.lst # minimal install custom_hypr.lst + custom_app.lst without configs
```

- each [section](#process) can also be independently executed as,
```shell
./install.sh -i # minimal install hyprland without any configs
./install.sh -d # minimal install hyprland without any configs, but with (--noconfirm) install
./install.sh -r # just restores the config files
./install.sh -s # start and enable system services
./install.sh -drs # same as ./install.sh, but with (--noconfirm) install
```

