HISTFILE="$XDG_DATA_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
[[ -d "$XDG_DATA_HOME/zsh" ]] && mkdir -p "$XDG_DATA_HOME/zsh/"
[[ -f "$XDG_DATA_HOME/zsh/history" ]] && touch "$XDG_DATA_HOME/zsh/history"

bindkey -v # vim mode
export KEYTIMEOUT=1
bindkey -v '^?' backward-delete-char

setopt extendedglob nomatch menucomplete
unsetopt BEEP
stty stop undef # disable ctrl-s freezing the terminal
zle_highlight=('paste:none') # stop highlighting pasted text

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search

export FZF_DEFAULT_OPTS='--height 40%'
[ -f /usr/share/fzf/shell/key-bindings.zsh ] && source /usr/share/fzf/shell/key-bindings.zsh

zstyle :compinstall filename "$ZDOTDIR/.zshrc"
zstyle ':completion:*' menu select
autoload -Uz compinit
_comp_options+=(globdots)
compinit

export DISABLE_AUTO_TITLE=true

export ZAP_DIR="$HOME/.local/share/zap"
[[ ! -d "$ZAP_DIR" ]] && {
    git clone https://github.com/zap-zsh/zap.git "$ZAP_DIR" > /dev/null 2>&1
}
[[ -f "$ZAP_DIR/zap.zsh" ]] && {
    source "$ZAP_DIR/zap.zsh"
    plug "zsh-users/zsh-autosuggestions"
    plug "zsh-users/zsh-syntax-highlighting"
}

function up-arch {
    pushd "$HOME/dots"
    git pull 
    popd
    zap update
    { sudo -i -u kain paru } && \
    rustup up && \
    nvim -c 'lua require("lazy").sync()'
    pushd "$HOME/Downloads/zls/" && git pull && zig build -Doptimize=ReleaseSafe -p ~/.local/ && popd
}

function up-mac {
    pushd "$HOME/dots"
    git pull
    popd
    zap update
    brew update && brew upgrade
    rustup up
    poetry self update
    nvim -c 'lua require("lazy").sync()'
}

function tmux-work {
    smug dots --detach
    smug planning_core
}

alias gg="lazygit"
alias cp="cp -i"
alias rm="rm -i"
alias mv="mv -i"
alias ls="exa"
alias ll="ls -lg --git"
alias la="ls -a"
alias lla="ll -a"
alias lt="ls --tree"
alias vim="nvim"
alias emacs="emacsclient -c -a 'emacs'"

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
export PATH="$HOME/.cargo/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/tommy/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/tommy/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/tommy/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/tommy/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<



# Load Angular CLI autocompletion.
(( $+commands[ng] )) && source <(ng completion script) || true
