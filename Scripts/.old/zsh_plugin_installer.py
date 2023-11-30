#! /usr/bin/python3

# |---/ /+----------------------------------------+---/ /|#
# |--/ /-| Script to install pkgs from input list |--/ /-|#
# |-/ /--| Effibot                                |-/ /--|#
# |/ /---+----------------------------------------+/ /---|#

import argparse

# get reference to directories
# ZSH_FOLDER="/usr/share/oh-my-zsh"
import os
from os.path import exists, expanduser, isdir, join

# define folders
global ZSH_FOLDER
global ZSH_CUSTOM_PLUGINS
global WORKARAOUND
global RC_FILE
# those folders are hardcoded for now because the script is
# meant to be used with the configuration of main install script
ZSH_FOLDER = expanduser("/usr/share/oh-my-zsh")
ZSH_CUSTOM_PLUGINS = join(ZSH_FOLDER, "custom/plugins")
WORKARAOUND = False
RC_FILE = os.getenv('ZDOTDIR', default='') if os.getenv('ZDOTDIR', default='') != '' else expanduser(f"/home/{os.getlogin()}/.zshrc")
# this is a workaround string to be able to load the completion plugin manually
workaround = "fpath+=${ZSH_CUSTOM:-${ZSH:-/usr/share/oh-my-zsh}/custom}/plugins/zsh-completions/src"


def get_plugin_list(input_file):
    # read the input file
    with open(input_file, "r") as f:
        plugin_list = [line.strip() for line in f.readlines()]
    if "zsh-completions" in plugin_list:
        WORKARAOUND = True
    return plugin_list


def generate_plugin_block(plugin_list):
    """generate the line for the .zshrc file to load the plugins"""
    line = "plugins=("
    to_download = []
    for plugin in plugin_list:
        # checks if the plugin comes from a git repo
        if plugin.startswith("http"):
            # if it does, append it to the list of plugins to download
            to_download.append(plugin)
            # get the name of the plugin and append it to the line
            plugin_name = plugin.split("/")[-1].split(".")[0]
            line += f"{plugin_name} "
        else:
            # if not, it is assumed that the plugin is in the default plugin folder
            line += f"{plugin} "
    line += ")\n"
    return line, to_download


def download_plugins(to_download):
    """downloads the plugins from the list of plugins"""
    for plugin in to_download:
        plugin_name = plugin.split("/")[-1].split(".")[0]
        plugin_folder = join(ZSH_CUSTOM_PLUGINS, plugin_name)
        if not exists(plugin_folder) and not isdir(plugin_folder):
            # os.makedirs(plugin_folder)
            print(f"Downloading plugins: {plugin_name} from {plugin}")
            os.system(f"git clone {plugin} {plugin_folder}")
        else:
            print(f"Plugin {plugin_name} already exists")


def main(input_file) -> None:
    print("\nInstalling ZSH plugins\n")
    # get the list of plugins
    plugin_list = get_plugin_list(input_file)
    # generate the line to be added to the .zshrc file
    plugin_line, to_download = generate_plugin_block(plugin_list)
    print(f"Your desired plugins are: {plugin_line}")
    if WORKARAOUND:
        print("Workaround is needed to load the completion plugin")
        plugin_line += workaround + "\n"
    # download the plugins
    download_plugins(to_download)
    # add the line to the .zshrc file
    updated_line = ""
    print(f"rc file is {RC_FILE}")
    try:
        with open(RC_FILE, "r") as f:
            # search for the line that loads the plugins
            f_content = f.read()
        updated_line = f_content.replace("plugins=(git)", plugin_line)
        with open(RC_FILE, "w") as g:
            g.write(updated_line)
            print("Plugin list updated")

    except FileNotFoundError:
        print("File not found")
    except IOError as e:
        print(f"IO error -> {e}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser("Input file containing list of plugins")
    parser.add_argument("-f", help="Input file containing list of plugins")
    input_file = parser.parse_args().f
    main(input_file)
