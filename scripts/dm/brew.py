from brew_base import BREW_BASE

BREW = {
    # qmk
    'tap "qmk/qmk"'
    'brew "qmk/qmk/qmk"'
    'tap "osx-cross/arm"'
    'tap "osx-cross/avr"'
    # tools, code, terminal
    'brew "neovim", args: ["HEAD"]'
    'brew "tmux"'
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
    'brew "git-delta"'
    'brew "lazygit"'
    'brew "rm-improved"'
    'brew "direnv"'
    'brew "hyperfine"'
    'brew "tokei"'
    'brew "just"'
    'brew "starship"'
    'brew "fastfetch"'
    # LSPs, formatters, linters
    'brew "marksman"'
    'brew "stylua"'
    'brew "prettier"'
    'brew "eslint"'
    'brew "shellcheck"'
    'brew "shfmt"'
    'brew "yamllint"'
    'brew "editorconfig"'
    # GUI
    'cask "alacritty"'
    'cask "amethyst"'
    'cask "telegram-desktop"'
    'cask "obsidian"'
}


def brew() -> set[str]:
    return BREW.union(BREW_BASE)
