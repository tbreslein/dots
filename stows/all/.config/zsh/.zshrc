disable log
HISTFILE=$HOME/.zsh_history
HISTSIZE=20000
SAVEHIST=10000

unsetopt BEEP

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

fzf-git-branch() {
    git rev-parse HEAD >/dev/null 2>&1 || return
    git branch --color=always --all --sort=-committerdate |
        grep -v HEAD |
        fzf --height 50% --ansi --no-multi |
        sed "s/.* //"
}
fzf-git-checkout() {
    git rev-parse HEAD >/dev/null 2>&1 || return
    local branch
    branch=$(fzf-git-branch)
    if [[ "$branch" = "" ]]; then
        echo "No branch selected."
        return
    fi
    if [[ "$branch" = 'remotes/'* ]]; then
        git checkout --track "$branch"
    else
        git checkout "$branch"
    fi
}
alias gb="fzf-git-branch"
alias gco="fzf-git-checkout"

alias g="git"
alias gg="git status"
alias gs="git switch"
alias ga="git add"
alias gaa="git add ."
alias gc="git commit"
alias gca="git commit --all"
alias gcA="git commit --amend --no-edit"
alias gB="git checkout -b"
alias gp="git pull"
alias gP="git push origin"
alias gPF="git push --force-with-lease"
alias gPU="git push --set-upstream"
alias lg="lazygit"
alias v="nvim"
alias ls="eza --icons=always"
alias la="eza -aa"
alias ll="eza -l"
alias lla="eza -la"
alias lt="eza --tree"
alias cp="cp -i"
alias rm="rm -i"
alias mv="mv -i"
alias mkdir="mkdir -p"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias dm="nix run $HOME/dots# --"

alias rip_nvim="rip ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim ~/dots/nvim/lazy-lock.json"

twork() {
    tmux new-session -ds "work" -c "$HOME/work/"
    tmux send-keys -t "work" "just toggle_moco" C-m
    tmux a -t "work"
}

eval "$(fzf --zsh)"
eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
# eval "$(just --completions zsh)" # doesn't seem to properly work for zsh

fastfetch -l small
