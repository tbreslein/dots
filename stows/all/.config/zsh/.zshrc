disable log
HISTFILE=$HOME/.zsh_history
HISTSIZE=20000
SAVEHIST=10000
setopt appendhistory histignorealldups histignorespace

setopt autocd menucomplete extended_glob nomatch interactivecomments
stty stop undef
zle_highlight=('paste:none')
unsetopt BEEP
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export MANPAGER='nvim +Man!'
export MANWIDTH=999

source "$ZDOTDIR/zsh-aliases"
source "$ZDOTDIR/zsh-plugins"

# Load and initialise completion system
autoload -Uz compinit && compinit
zstyle ':completion:*' menu no
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*:git-checkout:*' sort false

autoload edit-command-line
zle -N edit-command-line

bindkey -s '^z' 'zi^M'
bindkey '^e' edit-command-line
bindkey -s '^x' 'jf^M'

twork() {
    if [ -n "$TMUX" ]; then
        pushd "$HOME/work"
        just toggle_moco
        popd
        if ! tmux has-session -t work; then
            tmux new-session -ds "work" -c "$HOME/work"
        fi
    else
        tmux new-session -ds "work" -c "$HOME/work/"
        tmux send-keys -t "work" "just toggle_moco" C-m
        tmux a -t "work"
    fi
}

eval "$(fzf --zsh)"
export DIRENV_LOG_FORMAT=
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

if command -v tmux &>/dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    exec tmux new-session -A -s home
fi
