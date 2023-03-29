HISTFILE="$XDG_DATA_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
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

export ZAP_DIR="$HOME/.local/share/zap"
[[ ! -d "$ZAP_DIR" ]] && {
    git clone https://github.com/zap-zsh/zap.git "$ZAP_DIR" > /dev/null 2>&1
}
[[ -f "$ZAP_DIR/zap.zsh" ]] && {
    source "$ZAP_DIR/zap.zsh"
    plug "zsh-users/zsh-autosuggestions"
    plug "zsh-users/zsh-syntax-highlighting"
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

. "$HOME/.cargo/env"
export PATH=~/.local/bin:$PATH
export PATH=~/.npm_global/bin:$PATH
export GOPATH=$HOME/.local/share/go
export PATH=~/.local/share/go/bin:$PATH

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
