#!/usr/bin/env python

from copy import deepcopy
import os
import subprocess as sp
from typing import Tuple
import typer

from dmconfig import CONFIG
from dmutils import init_cmd, info, warn, success, err, sprun

app = typer.Typer()


@app.command()
def stow():
    """Ensures all necessary stows are up-to-date."""
    init_cmd()

    gstatus = sp.run(
        ["git", "status", "--porcelain"], cwd=CONFIG.dots, capture_output=True
    )
    if len(gstatus.stdout) > 0:
        err(
            "git status --porcelain return non-zero return code."
            f" stdout: {gstatus.stdout}"
        )
        exit(1)

    stows = deepcopy(CONFIG.roles)
    stows.add(CONFIG.host)
    for stow in stows:
        stow_dir = os.path.join(CONFIG.stows, stow)
        if not os.path.isdir(stow_dir):
            continue
        sp.run(
            [
                "stow",
                "-n",
                "-v",
                "--no-folding",
                "--adopt",
                "-t",
                CONFIG.home,
                "-d",
                stow_dir,
            ],
            capture_output=True,
        )
    sp.run(["git", "restore", "."])


@app.command()
def nix():
    """Syncs nix channels."""

    init_cmd()
    sprun(["nix-channel", "--update"])
    # sprun(["nix-store", "--gc"])
    # sprun(["nix-store", "--optimise"])
    sprun(["nix-store", "--gc", "--optimise"])
    success("finished!")


@app.command()
def repos():
    """Ensures all necessary git repos are cloned and up-to-date."""

    init_cmd()
    if "code" not in CONFIG.roles:
        warn(f'host {CONFIG.host} does not have "code" role; skipping')
        return
    ps = []
    for repo in CONFIG.repos:
        info(f"syncing repo: {repo}")
        name_start = repo.rfind("/") + 1
        name_end = repo.rfind(".")
        folder = os.path.join(CONFIG.home, "code", repo[name_start:name_end])
        if os.path.isdir(folder):
            ps.append(sp.Popen(["git", "pull"], cwd=folder))
        else:
            ps.append(sp.Popen(["git", "clone", repo, folder]))
    while not all(p.poll() is not None for p in ps):
        pass
    success("finished!")


@app.command()
def pkgs():
    """Ensures all necessary packages are installed and up-to-date."""

    init_cmd()
    match CONFIG.host:
        case "darwin":
            brewfile_path = os.path.join(CONFIG.state, "Brewfile")
            with open(brewfile_path, mode="w+") as f:
                f.write("\n".join(CONFIG.brew))
            sprun(["brew", "bundle", "--cleanup", "--file", brewfile_path, "install"])
        case "vorador":
            (pkgs_needed, pkgs_remove) = _manage_pkg_state("apt", CONFIG.apt)
            sprun(["sudo", "update"])
            sprun(["sudo", "apt", "install", " ".join(pkgs_needed)])
            sprun(["sudo", "apt", "remove", " ".join(pkgs_remove)])
            sprun(["sudo", "upgrade", "--autoremove"])
        case _:
            (pacman_needed, pacman_remove) = _manage_pkg_state("pacman", CONFIG.pacman)
            sprun(["sudo", "pacman", "-Syu"])
            sprun(["sudo", "pacman", "-S", "--needed", " ".join(pacman_needed)])
            sprun(["sudo", "pacman", "-R", " ".join(pacman_remove)])
            with open(os.path.join(CONFIG.state, "pacman"), mode="w+") as f:
                f.write("\n".join(CONFIG.pacman))

            (paru_needed, paru_remove) = _manage_pkg_state("aur", CONFIG.pacman)
            sprun(["sudo", "paru", "-Syu"])
            sprun(["sudo", "paru", "-S", "--needed", " ".join(paru_needed)])
            sprun(["sudo", "paru", "-R", " ".join(paru_remove)])
            with open(os.path.join(CONFIG.state, "aur"), mode="w+") as f:
                f.write("\n".join(CONFIG.aur))
    success("finished!")


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
    pkgs_installed_file = os.path.join(CONFIG.state, pkg_manager)
    if os.path.isfile(pkgs_installed_file):
        with open(os.path.join(CONFIG.state, pkg_manager), mode="r") as f:
            pkgs_installed.update(set(f.readlines()))
    pkgs_needed = [p for p in pkgs if p not in pkgs_installed]
    pkgs_remove = [p for p in pkgs_installed if p not in pkgs]
    return (pkgs_needed, pkgs_remove)


@app.command()
def nvim():
    """Syncs nvim plugins."""

    init_cmd()
    p = sp.run(
        ["nvim", "--headless", '"Lazy! sync"', "TSUpdateSync", "+qa"],
        env={"CC": "gcc", "CXX": "g++", "PATH": CONFIG.path},
        capture_output=True,
    )
    if p.returncode != 0:
        err(f"{p.stderr}")
        exit(1)
    success("finished!")


@app.command()
def sync():
    """Runs all maintenance commands: stow, nix, repos, pkgs, nvim."""

    init_cmd()
    # stow()
    # nix()
    # repos()
    # pkgs()
    nvim()
    CONFIG.command = "sync"
    success("finished!")


@app.callback(invoke_without_command=True)
def main():
    """Run sync as the default command."""
    sync()


if __name__ == "__main__":
    app()
