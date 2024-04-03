#!/usr/bin/env zsh

export EDITOR=nvim
export VISUAL=nvim
export BROWSER=brave

[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
[ -d "/opt/homebrew/bin" ] && export PATH="/opt/homebrew/bin:$PATH"
[ -d "/opt/homebrew/sbin" ] && export PATH="/opt/homebrew/sbin:$PATH"
[ -d "$HOME/.cargo" ] && [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
[ -f "$HOME/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh" ] &&
    source "$HOME/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh"
