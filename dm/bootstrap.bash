#!/usr/bin/env bash

set -euo pipefail
readonly BOLD_RED='\033[1;31m'
readonly BOLD_GREEN='\033[1;32m'
readonly BOLD_YELLOW='\033[1;33m'
readonly BOLD_BLUE='\033[1;34m'
readonly NC='\033[0m'
readonly SCRIPTPATH="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

${SCRIPTPATH}/refresh_env
source "${SCRIPTPATH}/.env"

mkdir -p ~/.local/bin
if [ ! -L "$HOME/.local/bin/dm" ]; then
    ln -s ~/dots/dm ~/.local/bin/dm
fi

print_section() {
    echo -e "\n${BOLD_GREEN}[ $1 ]${NC}\n"
}
print_info() {
    echo -e "${BOLD_BLUE}[ bootstrap ] INFO    |${NC} $1"
}
print_warn() {
    echo -e "${BOLD_YELLOW}[ bootstrap ] WARN    |${NC} $1"
}
print_success() {
    echo -e "${BOLD_GREEN}[ bootstrap ] SUCCESS |${NC} $1"
}
print_error() {
    echo -e "${BOLD_RED}[ bootstrap ] ERROR   |${NC} $1"
}

print_section bootstrap
print_info "script path: $SCRIPTPATH"

print_info "setting up /etc/hosts"
if [ ! -f /etc/hosts ]; then
    sudo bash -s "echo \"127.0.0.1       localhost\" > /etc/hosts"
    sudo bash -s "echo \"255.255.255.255 broadcasthost\" >> /etc/hosts"
    sudo bash -s "echo \"::1             localhost\" >> /etc/hosts"
fi
hosts=(
    "192.168.178.90 vorador"
)
for host in "${hosts[@]}"; do
    if ! grep -q "${host}" /etc/hosts; then
        sudo bash -c "echo \"${host}\" >> /etc/hosts"
    fi
done
print_success "set up /etc/hosts"

if [[ ${ROLES[@]} =~ code ]]; then
    print_info "setting up role: code"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
if [[ ${ROLES[@]} =~ gaming ]]; then
    print_info "setting up role: gaming"
    sudo groupadd gamemode
    sudo usermod -aG gamemode tommy
    print_success "set up role: gaming"
fi

if [[ ${ROLES[@]} =~ laptop ]]; then
    print_info "setting up role: laptop"
    sudo systemctl enable tlp.service
    sudo systemctl start tlp.service
    print_success "set up role: laptop"
fi

if [[ ${ROLES[@]} =~ linux ]]; then
    print_info "setting up role: linux"
    if [[ ${_HOST} =~ ^(moebius|audron)$ ]]; then
        sudo pacman -S --needed base-devel syncthing stow networkmanager pacman-contrib
        systemctl --user enable syncthing.service
        systemctl --user start syncthing.service

        # git clone https://aur.archlinux.org/paru.git ~/paru
        pushd ~/paru
        makepkg -si
        popd

        sudo systemctl enable paccache.timer
        sudo systemctl start paccache.timer

        if [[ ${ROLES[@]} =~ x11 ]]; then
            if [[ "$X11_WM" == "dwm" ]]; then
                mkdir -p "$HOME/code"
                git clone "https://www.github.com/tbreslein/dwm.git" "$HOME/code/dwm"
                pushd "$HOME/code/dwm"
                git remote remove origin
                git remote add origin git@github.com:tbreslein/dwm.git
                sudo make clean install
                popd
            fi
        elif [[ ${ROLES[@]} =~ wayland ]]; then
            sudo pacman -S --needed greetd
            if [ ! -f /etc/greetd/config.toml ]; then
                sudo mkdir -p /etc/greetd
                sudo teouch /etc/greetd/config.toml
            fi
            autologin="[initial_session]
            command = \"Hyprland --config /etc/greetd/hyprland.conf\"
            user = \"tommy\""
            if [[ $(</etc/greetd/config.toml) = *"${autologin}"* ]]; then
                sudo bash -c "echo ${autologin} > /etc/greetd/config.toml"
            fi
            sudo systemctl --enable greetd.service
        fi
    elif [[ ${_HOST} == "vorador" ]]; then
        sudo apt install -y syncthing
    fi

    if ! command -v -- "nix" >/dev/null 2>&1; then
        sh <(curl -L https://nixos.org/nix/install) --daemon
    else
        print_info "nix is already installed; skipping"
    fi
    print_success "set up role: linux"
fi

if [[ ${ROLES[@]} =~ darwin ]]; then
    print_info "setting up role: darwin"

    if ! command -v -- "nix" >/dev/null 2>&1; then
        sh <(curl -L https://nixos.org/nix/install)
    else
        print_info "nix is already installed; skipping"
    fi

    if ! command -v -- "brew" >/dev/null 2>&1; then
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        print_info "brew is already installed; skipping"
    fi

    print_success "set up role: darwin"
fi
