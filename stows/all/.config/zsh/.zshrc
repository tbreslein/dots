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

export PLUGINDIR="$HOME/.local/share/zsh/plugins"
export PLUGINS=()
mkdir -p "$PLUGINDIR"
zsh_source_plugins

eval "$(fzf --zsh)"
eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
# eval "$(just --completions zsh)" # doesn't seem to properly work for zsh

fastfetch -l small
