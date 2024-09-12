#!/usr/bin/env bash
#|---/ /+----------------------------------------+---/ /|#
#|--/ /-| Script to install pkgs from input list |--/ /-|#
#|-/ /--| Matthieu Amet                          |-/ /--|#
#|-/ /--| Prasanth Rangan                        |-/ /--|#
#|/ /---+----------------------------------------+/ /---|#

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/../global_fn.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

install_git_1() {
    cmake -DCMAKE_INSTALL_PREFIX=/usr -B build
    cmake --build build -j`nproc`
    sudo cmake --install build
}

install_git_2() {
    cmake --no-warn-unused-cli -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B build
    cmake --build build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
    sudo cmake --install build
}

install_git_3() {
    ./configure
    make all && sudo make install
}

install_git_4() {
    meson build
    ninja -C build
    sudo ninja -C build install
}

# Install dependencies and software
listPkg="${1:-"${scrDir}/deps.lst"}"
echo -e "\033[0;31mNote: Installing with APT in CLI is at risks, be sure you know what you do before continuing.\033[0m You can install the packages manually and go back to this script if needed."
read -p " :: Press y to continue : " aptwarning
case ${aptwarning} in
    y) ;;
    *) exit ;;
esac
while read -r pkg; do
    pkg="${pkg// /}"
    if [ -z "${pkg}" ]; then
        continue
    fi
    if pkg_installed "${pkg}"; then
        echo -e "\033[0;33m[skip]\033[0m ${pkg} is already installed..."
    elif pkg_available "${pkg}"; then
        echo -e "\033[0;32m[o]\033[0m Installing ${pkg} from official debian repo..."
        sudo apt install -y --force-yes ${pkg} &>/dev/null
    else
        echo "Error: unknown package ${pkg}..."
    fi
done < <(cut -d '#' -f 1 "${listPkg}")

# Installing Rust
echo -e "\033[0;32m[o]\033[0m Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

# Install git packages
listPkg="${1:-"${scrDir}/git.lst"}"
while read -r input; do
    input="${input// /}"
    if [ -z "${input}" ]; then
        continue
    fi
    prefix=$(echo "$input" | cut -d':' -f1)
    gitpkg=$(echo "$input" | cut -d':' -f2-)
    echo -e "\033[0;32m[o]\033[0m Installing ${gitpkg} from git repo..."
    pkgname=$(echo "${gitpkg}" | sed 's|.*/\([^/]*\)/\([^/]*\)\.git|\1_\2|')
    if [ ! -d "${pkgname}" ] ; then
        git clone --depth 1 --recursive ${gitpkg} ${pkgname}
    else
        cd "${pkgname}"
        git pull --depth 1 ${gitpkg}
        git submodule update --recursive
        cd ..
    fi
    cd "${pkgname}"
    if [ "$prefix" == "1" ]; then
        install_git_1 ${pkgname}
    elif [ "$prefix" == "2" ]; then
        install_git_2 ${pkgname}
    elif [ "$prefix" == "3" ]; then
        install_git_3 ${pkgname}
    elif [ "$prefix" == "4" ]; then
        install_git_4 ${pkgname}
    else
        echo -e "\033[0;31mUnknown installation for ${gitpkg}\033[0m"
    fi
    cd ..
done < <(cut -d '#' -f 1 "${listPkg}")

# Install softwares
listPkg="${1:-"${scrDir}/softwares.lst"}"
while read -r input; do
    input="${input// /}"
    if [ -z "${input}" ]; then
        continue
    fi
    echo -e "\033[0;32m[o]\033[0m Installing ${input}..."
    source "${scrDir}/install_${input}.sh"
done < <(cut -d '#' -f 1 "${listPkg}")

if [ "${myShell}" == "zsh" ]; then
    echo -e "\033[0;32m[o]\033[0m Installing oh-my-zsh..."
    sudo apt install -y zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone --depth 1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    sed -i 's/ZSH_THEME="[^"]*"/ZSH_THEME="powerlevel10k/powerlevel10k"/' ~/.zshrc
elif [ "${myShell}" == "fish" ]; then
    echo -e "\033[0;32m[o]\033[0m Installing fish..."
    sudo apt install -y fish
    curl -sS https://starship.rs/install.sh | sh
    mkdir -p ~/.config/fish
    sudo cp /etc/fish/config.fish ~/.config/fish/config.fish
    sudo chown $USER:$USER ~/.config/fish/config.fish
    echo "starship init fish | source" >> ~/.config/fish/config.fish
else
    echo -e "\033[0;33m[o]\033[0m No shell selected"
fi

source "${scrDir}/install_swww.sh"
