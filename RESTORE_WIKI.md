# HyDE Wiki - Restore

## Overview

HyDE provides scripts and list files to manage it's dotfiles and configurations efficiently. The `restore_cfg.sh` script restores dotfiles from the HyDE directory and backs up your current dotfiles based on instructions in `restore_cfg.lst`.

Those scripts are listed below:

- `restore_cfg.sh`: Restores dotfiles from the repository and backs up your current dotfiles.
- `restore_fnt.sh`: Restores fonts from the repository.
- `restore_shl.sh`: Restores shells from the user.
- `restore_zsh.sh`: Restores zsh shell from the repository.

Example usage:

```shell
./install.sh -r
```

- `-r`: Restores dotfiles from the repository and backs up your current dotfiles that have the `backupflag` set to `Y` in `restore_cfg.lst`.

### Restore Configs list syntax

The `restore_cfg.lst` file contains instructions for the `restore_cfg.sh` script. It is a list of configurations to be restored and backed up. The `|` symbol indicates a new instruction.

The `restore_cfg.lst` syntax is as follows:

```shell
backupflag|overwriteflag|path|config|package
```

- `backupflag` (Y/N): Indicates if the files should be backed up before restoration.
- `overwriteflag` (Y/N): Indicates if existing files should be overwritten during restoration.
- `path` (`~/.config/hypr`): Path of the file to be restored.
- `config` (file1.conf folder1): Name of the configuration file or folder.
- `package` (`hyprland nvidia-utils`): Packages requiring these files; restoration is skipped if packages are not installed.

## Contributions

Feel free to contribute to this project by submitting issues or pull requests. Ensure to follow the contribution guidelines provided in `CONTRIBUTING.md`.

## License

This project is licensed under the GPL-3.0 License. See the `LICENSE` file for more details.

## Contact

For any queries, reach out to the maintainer at [GitHub](https://github.com/prasanthrangan/hyprdots).
