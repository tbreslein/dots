from copy import deepcopy
from typing import Tuple

from arch_base import BASE_AUR, BASE_PACMAN

PACMAN_CODE: set[str] = {
    "neovim",
    "direnv",
    "tmux",
    "editorconfig-core-c",
    "marksman",
    "stylua",
    "prettier",
    "eslint",
    "shellcheck",
    "shfmt",
    "yamllint",
    "git-delta",
    "hyperfine",
    "tokei",
}

PACMAN_DESKTOP: set[str] = {
    "imv",
    "mpv",
    "alacritty",
    "wezterm",
    "wezterm-terminfo",
    "vlc",
    "discord",
    "thunar",
    "obsidian",
    "ttf-hack-nerd",
    "telegram-desktop",
    "grub",
    "grub-btrfs",
    "efibootmgr",
    "btrfs-progs",
    "snapper",
    "network-manager-applet",
    "hyprland",
    "hyprpaper",
    "hypridle",
    "hyprlock",
    "xdg-desktop-portal-hyprland",
    "bemenu-wayland",
    "wl-clipboard",
    "wlsunset",
    "grim",
    "slurp",
    "dunst",
    "libnotify",
    "kanshi",
    "waybar",
    "playerctl",
    "pavucontrol",
    "brightnessctl",
    "polkit-kde-agent",
    "blueman",
    "qt5-wayland",
    "qt6-wayland",
    "pipewire",
    "wireplumber",
    "pipewire-alsa",
    "pipewire-jack",
    "pipewire-pulse",
    "greetd",
    "zathura",
    "zathura-ps",
    "zathura-pdf-mupdf",
    "noto-fonts",
    "noto-fonts-cjk",
    "noto-fonts-emoji",
    "noto-fonts-extra",
}

AUR_DESKTOP: set[str] = {
    "hyprshot",
    "satty-bin",
    "wdisplays",
    "proton-ge-custom-bin",
    "brave-bin",
    "microsoft-edge-stable-bin",
}

PACMAN_LAPTOP: set[str] = {"tlp"}

PACMAN_GAMING: set[str] = {"steam", "gamemode", "lib32-gamemode"}

PACMAN_MOEBIUS: set[str] = {
    "os-prober",
    "amd-ucode",
    "mesa",
    "lib32-mesa",
    "vulkan-radeon",
    "lib32-vulkan-radeon",
    "libva-mesa-driver",
    "lib32-libvs-mesa-driver",
    "mesa-vdpau",
    "lib32-mesa-vdpau",
}

PACMAN_AUDRON: set[str] = {"intel-ucode"}


def arch(roles: set[str], host: str) -> Tuple[set[str], set[str]]:
    PACMAN = deepcopy(BASE_PACMAN)
    AUR = deepcopy(BASE_AUR)

    if "code" in roles:
        PACMAN.update(PACMAN_CODE)
    if "desktop" in roles:
        PACMAN.update(PACMAN_DESKTOP)
        AUR.update(AUR_DESKTOP)
    if "laptop" in roles:
        PACMAN.update(PACMAN_LAPTOP)
    if "gaming" in roles:
        PACMAN.update(PACMAN_GAMING)
    if host == "moebius":
        PACMAN.update(PACMAN_MOEBIUS)
    if host == "audron":
        PACMAN.update(PACMAN_AUDRON)

    return (PACMAN, AUR)
