#!/usr/bin/env python

import inspect
import os
import subprocess as sp
from typing import Tuple
import typer
from copy import deepcopy
from dotenv import load_dotenv


os.system("")


class Config:
    def __init__(self):
        self.roles: set[str] = {r for r in (os.environ.get("ROLES") or "").split()}
        self.host: str = os.environ.get("_HOST") or ""
        self.uname: str = os.environ.get("UNAME_S") or ""
        self.path: str = os.environ.get("PATH") or ""
        self.home: str = os.environ.get("HOME") or ""
        self.dots: str = os.path.join(self.home, "dots")
        self.stows: str = os.path.join(self.dots, "stows")
        self.state: str = os.path.join(self.dots, "state")
        self.repos: list[str] = (os.environ.get("REPOS") or "").split()
        self.red: str = "\033[0;31m"
        self.green: str = "\033[0;32m"
        self.yellow: str = "\033[0;33m"
        self.blue: str = "\033[0;34m"
        self.bright_red: str = "\033[1;31m"
        self.bright_green: str = "\033[1;32m"
        self.bright_yellow: str = "\033[1;33m"
        self.bright_blue: str = "\033[1;34m"
        self.no_color: str = "\033[0m"
        self.command: str = ""
        self.allowed_hosts: set[str] = {
            h for h in (os.environ.get("ALLOWED_HOSTS") or "")
        }

        self.brewfile_pkgs: set[str] = {
            'tap "homebrew/bundle"'
            'tap "jstkdng/programs"'
            'tap "homebrew/cask-fonts"'
            'tap "osx-cross/arm"'
            'tap "osx-cross/avr"'
            'tap "qmk/qmk"'
            'brew "neovim", args: ["HEAD"]'
            'brew "coreutils"'
            'brew "tree"'
            'brew "tldr"'
            'brew "htop"'
            'brew "yazi"'
            'brew "ffmpegthumbnailer"'
            'brew "unar"'
            'brew "poppler"'
            'brew "zoxide"'
            'brew "jq"'
            'brew "fd"'
            'brew "ripgrep"'
            'brew "eza"'
            'brew "bat"'
            'brew "git"'
            'brew "git-crypt"'
            'brew "lazygit"'
            'brew "rm-improved"'
            'brew "direnv"'
            'brew "marksman"'
            'brew "stylua"'
            'brew "prettier"'
            'brew "eslint"'
            'brew "tmux"'
            'brew "shellcheck"'
            'brew "shfmt"'
            'brew "yamllint"'
            'brew "editorconfig"'
            'brew "git-delta"'
            'brew "hyperfine"'
            'brew "tokei"'
            'brew "just"'
            'brew "starship"'
            'brew "fastfetch"'
            'brew "gnu-sed"'
            'brew "bash"'
            'brew "bash-completion@2"'
            'brew "syncthing", restart_service: true'
            'brew "qmk/qmk/qmk"'
            'cask "alacritty"'
            'cask "amethyst"'
            'cask "telegram-desktop"'
            'cask "obsidian"'
        }
        self.pacman: set[str] = {
            "base",
            "base-devel",
            "linux",
            "linux-firmware",
            "openssh",
            "sudo",
            "moreutils",
            "networkmanager",
            "ufw",
            "wget",
            "curl",
            "less",
            "sed",
            "awk",
            "parallel",
            "p7zip",
            "gcc",
            "cmake",
            "man-db",
            "man-pages",
            "texinfo",
            "syncthing",
            "vim",
            "neovim",
            "eza",
            "fd",
            "ripgrep",
            "git",
            "lazygit",
            "yazi",
            "jq",
            "fzf",
            "just",
            "starship",
            "fastfetch",
            "git-crypt",
            "tree",
            "tldr",
            "htop",
            "bat",
        }
        self.aur: set[str] = {"ueberzugpp", "rm-improved"}
        self.apt: set[str] = {"syncthing", "git", "vim"}

        if "code" in self.roles:
            self.pacman.update(
                {
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
            )

        if "desktop" in self.roles:
            self.pacman.update(
                {
                    "imv",
                    "mpv",
                    "alacritty",
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
            )
            self.aur.update(
                {
                    "hyprshot",
                    "satty-bin",
                    "wdisplays",
                    "proton-ge-custom-bin",
                    "brave-bin",
                    "microsoft-edge-stable-bin",
                }
            )

        if "laptop" in self.roles:
            self.pacman.update({"tlp"})

        if "gaming" in self.roles:
            self.pacman.update({"steam", "gamemode", "lib32-gamemode"})

        if self.host == "moebius":
            self.pacman.update(
                {
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
            )

        if self.host == "audron":
            self.pacman.update({"intel-ucode"})


app = typer.Typer()
load_dotenv()
config = Config()


def _print(msg: str, label: str, color: str):
    foo = ""
    if config.command is None:
        foo = "dm"
    else:
        foo = f"dm: {config.command}"
    print(f"{color}[ {foo.ljust(9, ' ')} ] {label} | {config.no_color} {msg}")


def print_info(msg: str):
    _print(msg, "INFO    ", config.bright_blue)


def print_warn(msg: str):
    _print(msg, "WARN    ", config.bright_yellow)


def print_success(msg: str):
    _print(msg, "SUCCESS ", config.bright_green)


def print_error(msg: str):
    _print(msg, "ERROR   ", config.bright_red)


def _sprun(cmd: list[str]) -> sp.CompletedProcess[bytes]:
    """Wrapper function around subprocess.run that always passes PATH to env vars."""
    return sp.run(cmd, env={"PATH": config.path})


def _init_cmd():
    name = inspect.stack()[1][3]
    config.command = name
    print_info(f"starting {name}")


@app.command()
def stow():
    """Ensures all necessary stows are up-to-date."""
    _init_cmd()

    gstatus = sp.run(
        ["git", "status", "--porcelain"], cwd=config.dots, capture_output=True
    )
    if len(gstatus.stdout) > 0:
        print_error(
            "git status --porcelain return non-zero return code."
            f" stdout: {gstatus.stdout}"
        )
        exit(1)

    stows = deepcopy(config.roles)
    stows.add(config.host)
    for stow in stows:
        stow_dir = os.path.join(config.stows, stow)
        if not os.path.isdir(stow_dir):
            continue
        sp.run(
            [
                "stow",
                "-v",
                "--no-folding",
                "--adopt",
                "-t",
                config.home,
                "-d",
                stow_dir,
            ],
            capture_output=True,
        )
    sp.run(["git", "restore", "."])


@app.command()
def nix():
    """Syncs nix channels."""
    _init_cmd()
    _sprun(["nix-channel", "--update"])
    _sprun(["nix-store", "--gc"])
    _sprun(["nix-store", "--optimise"])
    print_success("finished!")


@app.command()
def repos():
    """Ensures all necessary git repos are cloned and up-to-date."""

    _init_cmd()
    if "code" not in config.roles:
        print_warn(f'host {config.host} does not have "code" role; skipping')
        return
    ps = []
    for repo in config.repos:
        print_info(f"syncing repo: {repo}")
        name_start = repo.rfind("/") + 1
        name_end = repo.rfind(".")
        folder = os.path.join(config.home, "code", repo[name_start:name_end])
        if os.path.isdir(folder):
            ps.append(sp.Popen(["git", "pull"], cwd=folder))
        else:
            ps.append(sp.Popen(["git", "clone", repo, folder]))
    while not all(p.poll() is not None for p in ps):
        pass
    print_success("finished!")


@app.command()
def pkgs():
    """Ensures all necessary packages are installed and up-to-date."""

    _init_cmd()
    match config.host:
        case "darwin":
            brewfile_path = os.path.join(config.state, "Brewfile")
            with open(brewfile_path, mode="w+") as f:
                f.write("\n".join(config.brewfile_pkgs))
            _sprun(["brew", "bundle", "--cleanup", "--file", brewfile_path, "install"])
        case "vorador":
            (pkgs_needed, pkgs_remove) = _manage_pkg_state("apt", config.apt)
            _sprun(["sudo", "update"])
            _sprun(["sudo", "apt", "install", " ".join(pkgs_needed)])
            _sprun(["sudo", "apt", "remove", " ".join(pkgs_remove)])
            _sprun(["sudo", "upgrade", "--autoremove"])
        case _:
            (pacman_needed, pacman_remove) = _manage_pkg_state("pacman", config.pacman)
            _sprun(["sudo", "pacman", "-Syu"])
            _sprun(["sudo", "pacman", "-S", "--needed", " ".join(pacman_needed)])
            _sprun(["sudo", "pacman", "-R", " ".join(pacman_remove)])
            with open(os.path.join(config.state, "pacman"), mode="w+") as f:
                f.write("\n".join(config.pacman))

            (paru_needed, paru_remove) = _manage_pkg_state("aur", config.pacman)
            _sprun(["sudo", "paru", "-Syu"])
            _sprun(["sudo", "paru", "-S", "--needed", " ".join(paru_needed)])
            _sprun(["sudo", "paru", "-R", " ".join(paru_remove)])
            with open(os.path.join(config.state, "aur"), mode="w+") as f:
                f.write("\n".join(config.aur))
    print_success("finished!")


def _manage_pkg_state(pkg_manager: str, pkgs: set[str]) -> Tuple[list[str], list[str]]:
    """
    Calculates the lists of packages that need to be installed and removed.

    It reads the current state file at ~/dots/state/{pkg_manager}, which acts as
    the list of currently user-installed packages. It compares that set to the
    set of packages we want to have installed now, and calculates and returns
    two lists: missing packages that need to be installed, and packages that can
    be removed.
    """
    pkgs_installed = set[str]()
    pkgs_installed_file = os.path.join(config.state, pkg_manager)
    if os.path.isfile(pkgs_installed_file):
        with open(os.path.join(config.state, pkg_manager), mode="r") as f:
            pkgs_installed.update(set(f.readlines()))
    pkgs_needed = [p for p in pkgs if p not in pkgs_installed]
    pkgs_remove = [p for p in pkgs_installed if p not in pkgs]
    return (pkgs_needed, pkgs_remove)


@app.command()
def nvim():
    """Syncs nvim plugins."""
    _init_cmd()
    p = sp.run(
        ["nvim", "--headless", '"Lazy! sync"', "TSUpdateSync", "+qa"],
        env={"CC": "gcc", "CXX": "g++", "PATH": config.path},
        capture_output=True,
    )
    if p.returncode != 0:
        print_error(f"{p.stderr}")
        exit(1)
    print_success("finished!")


@app.command()
def sync():
    """Runs all maintenance commands: stow, nix, repos, pkgs, nvim"""
    _init_cmd()
    # stow()
    # nix()
    # repos()
    # pkgs()
    nvim()
    config.command = "sync"
    print_success("finished!")


@app.callback(invoke_without_command=True)
def main():
    """Run sync."""
    sync()


if __name__ == "__main__":
    app()
