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
        fzf --height 50% --ansi --no-multi --preview-window right:65% \
            --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
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

    # If branch name starts with 'remotes/' then it is a remote branch. By
    # using --track and a remote branch name, it is the same as:
    # git checkout -b branchName --track origin/branchName
    if [[ "$branch" = 'remotes/'* ]]; then
        git checkout --track "$branch"
    else
        git checkout "$branch"
    fi
}
alias gb="fzf-git-branch"
alias gco="fzf-git-checkout"

alias g="git"
alias gs="git status"
alias gsw="git switch"
alias ga="git add"
alias gaa="git add ."
alias gc="git commit"
alias gca="git commit -a"
alias gcam="git commit --amend --no-edit"
alias gcaam="git commit -a --amend --no-edit"
alias gl="git pull"
alias gp="git push origin"
alias gpf="git push --force-with-lease"
alias gpu="git push --set-upstream"
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

twork() {
    tmux new-session -ds "work" -c "$HOME/work/"
    tmux send-keys -t "work" "just toggle_moco" C-m
    tmux a -t "work"
}

eval "$(fzf --zsh)"
eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
# eval "$(just --completions zsh)"

pfetch
