#!/usr/bin/env bash
#|---/ /+----------------------------------------+---/ /|#
#|--/ /-| Script to install swww                 |--/ /-|#
#|-/ /--| Matthieu Amet                          |-/ /--|#
#|-/ /--| Prasanth Rangan                        |-/ /--|#
#|/ /---+----------------------------------------+/ /---|#

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/../global_fn.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

if [ ! -d "swww" ] ; then
        git clone --depth 1 --recursive https://github.com/LGFae/swww.git
    else
        cd swww
        git pull --depth 1 https://github.com/LGFae/swww.git
        git submodule update --recursive
        cd ..
    fi

cd swww

source "$HOME/.cargo/env"
cargo build --release

sudo cp ./target/release/swww /usr/bin
sudo cp ./target/release/swww-daemon /usr/bin

sudo mkdir -p /usr/share/bash-completion/completions/
sudo cp completions/swww.bash /usr/share/bash-completion/completions/swww

if ! pkg_installed "zsh"; then
  echo -e "\033[0;31m[-]\033[0m zsh detected..."
  sudo mkdir -p /usr/share/zsh/site-functions/
  sudo cp completions/_swww /usr/share/zsh/site-functions/_swww
fi
if ! pkg_installed "fish"; then
  echo -e "\033[0;31m[-]\033[0m fish detected..."
  sudo mkdir -p /usr/shaare/fish/vendor_completions.d/
  sudo cp completions/swww.fish /usr/share/fish/vendor_completions.d/swww.fish
fi

cd ..
