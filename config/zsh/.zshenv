export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="brave"
export TERMINAL="alacritty"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export HISTFILE="$XDG_DATA_HOME/zsh/history"
export HISTSIZE=100000
export SAVEHIST=100000
[[ -d "$XDG_DATA_HOME/zsh" ]] && mkdir -p "$XDG_DATA_HOME/zsh/"
[[ -f "$XDG_DATA_HOME/zsh/history" ]] && touch "$XDG_DATA_HOME/zsh/history"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export BEMENU_OPTS='--fn "Hack Nerd Font 15" -i -l 20 --fb "#24273a" --ff "#8bd5ca" --nb "#24273a" --nf "#f4dbd6" --tb "#24273a" --hb "#24273a" --tf "#c6a0f6" --hf "#8aadf4" --af "#f4dbd6" --ab "#24273a"'

export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_QPA_PLATFORM=wayland
export GDK_BACKEND=wayland
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway
export MOZ_ENABLE_WAYLAND=1 # fixes thunderbird and firefox in wayland

[[ -d "$HOME/.cargo" ]] && [[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
export PATH=~/.local/bin:$PATH
export PATH=~/.zvm/bin:$PATH
export PATH=~/.emacs.d/bin:$PATH
export PATH=~/.npm_global/bin:$PATH
export GOPATH=$HOME/.local/share/go
export PATH=~/.local/share/go/bin:$PATH
export PATH=~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/:$PATH
