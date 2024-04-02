fish_add_path /opt/homebrew/bin/ ~/.local/bin

status --is-interactive; and begin
    set -g fish_greeting

    alias g git
    alias ga 'git add'
    alias gaa 'git add .'
    alias gb 'git branch'
    alias gc 'git commit'
    alias gca 'git commit -a'
    alias gcaam 'git commit -a --amend --no-edit'
    alias gcam 'git commit --amend --no-edit'
    alias gco 'git checkout'
    alias gl 'git pull'
    alias gmv 'git mv'
    alias gp 'git push origin'
    alias gpf 'git push --force-with-lease'
    alias gpu 'git push --set-upstream'
    alias gr 'git rebase'
    alias gra 'git rebase --abort'
    alias grc 'git rebase --continue'
    alias grm 'git rm'
    alias gs 'git status'
    alias gsw 'git switch'
    alias lg lazygit
    alias la 'eza -a'
    alias ll 'eza -l'
    alias lla 'eza -la'
    alias ls eza
    alias lt 'eza --tree'
    alias tcode 'tmuxp load home dots notes capturedlambda corries hydrie frankenrepo'
    alias twork 'tmuxp load home dots notes planning_docs planning_curls planning_schlogg planning_moco planning_work planning'
    alias v nvim

    # Interactive shell initialisation
    fzf_key_bindings
    direnv hook fish | source
    zoxide init fish | source
    just --completions fish | source
    eval (starship init fish)
end
