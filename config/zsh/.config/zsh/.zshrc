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
alias axbrew="arch -x86_64 /usr/local/Homebrew/bin/brew"

export ZAP_DIR="$HOME/.local/share/zap"
[[ ! -d "$ZAP_DIR" ]] && {
    git clone https://github.com/zap-zsh/zap.git "$ZAP_DIR" > /dev/null 2>&1
}
[[ -f "$ZAP_DIR/zap.zsh" ]] && {
    source "$ZAP_DIR/zap.zsh"
    plug "zsh-users/zsh-autosuggestions"
    plug "zsh-users/zsh-syntax-highlighting"
}

function up-all {
    [[ ! -d "~/.tmux/plugins/tpm" ]] && {
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm > /dev/null 2>&1
        ~/.tmux/plugins/tpm/bin/install_plugins
    }
    ~/.tmux/plugins/tpm/bin/update_plugins all
    zap update all
    rustup up && \
    opam update && \
    opam upgrade && \
    nvim --headless "+Lazy! sync" +qa
    nvim --headless +TSUpdateSync +qa
}

function up-arch {
    pushd "$HOME/dots"
    git pull 
    popd
    { sudo -i -u kain paru } && \
    up-all
    # pushd "$HOME/Downloads/zls/" && git pull && zig build -Doptimize=ReleaseSafe -p ~/.local/ && popd
}

function up-mac {
    pushd "$HOME/dots"
    git pull
    popd
    HOMEBREW_NO_INSTALL_CLEANUP=1 brew update && HOMEBREW_NO_INSTALL_CLEANUP=1 brew upgrade
    brew cleanup
    HOMEBREW_NO_INSTALL_CLEANUP=1 axbrew update && HOMEBREW_NO_INSTALL_CLEANUP=1 axbrew upgrade
    axbrew cleanup
    poetry self update
    up-all
}

function tmux-work {
    smug dots --detach
    smug planning
}

# function start-planning-profiler {
#     conda deactivate
#     conda activate planning_api
#     pushd ~/work/Planning/lib/planning_core_rust/
#     maturin develop --release --profile profiling
#     popd
#     samply record python3 ~/work/Planning/lib/planning_api_core_adapter/src/debug/debug_runner.py
# }

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/zig:$PATH"
export PATH="/opt/local/libexec/llvm-16/bin:$PATH"

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

# >>> pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null && eval "$(pyenv init --path --no-rehash)" || true
# <<< pyenv setup

[[ ! -r ~/.opam/opam-init/init.zsh ]] || source ~/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null


# Load Angular CLI autocompletion.
# (( $+commands[ng] )) && source <(ng completion script) || true
