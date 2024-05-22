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

source "$ZDOTDIR/zsh-functions"
source "$ZDOTDIR/zsh-aliases"
source "$ZDOTDIR/zsh-plugins"

# Load and initialise completion system
autoload -Uz compinit
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots)
compinit

autoload edit-command-line
zle -N edit-command-line

bindkey -s '^z' 'zi^M'
bindkey '^e' edit-command-line

eval "$(fzf --zsh)"
export DIRENV_LOG_FORMAT=
eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
# eval "$(just --completions zsh)" # doesn't seem to properly work for zsh
