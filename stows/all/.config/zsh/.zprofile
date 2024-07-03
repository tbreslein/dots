export EDITOR=nvim
export VISUAL=nvim
export BROWSER=brave

[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
[ -d "/opt/homebrew/bin" ] && export PATH="/opt/homebrew/bin:$PATH"
[ -d "/opt/homebrew/sbin" ] && export PATH="/opt/homebrew/sbin:$PATH"
[ -d "$HOME/.cargo" ] && [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
[ -d "/nix/var/nix/profiles/default/bin/" ] && export PATH="$PATH:/nix/var/nix/profiles/default/bin/"
[ -d "$HOME/.local/state/nix/profiles/profile/bin/" ] && export PATH="$PATH:$HOME/.local/state/nix/profiles/profile/bin"
[ -f "$HOME/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh" ] &&
    source "$HOME/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh"

if [ -d "$HOME/.local/bin/dm" ]; then
    export PATH="$HOME/.local/bin/dm:$PATH"
    $HOME/.local/bin/dm/refresh_env
    source $HOME/.local/bin/dm/.env
fi

if [[ "$HOSTNAME" =~ ^(moebius|audron)$ ]]; then
    if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        startx
    fi
fi
