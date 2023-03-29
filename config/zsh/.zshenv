export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="brave-browser"
export TERMINAL="alacritty"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

setxkbmap -option caps:escape
. "$HOME/.cargo/env"
