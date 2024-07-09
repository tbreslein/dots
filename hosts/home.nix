{
  config,
  userSettings,
  pkgs,
  ...
}: {
  home = {
    username = "${userSettings.userName}";
    stateVersion = "24.05";
    inherit (userSettings) sessionPath;
    inherit (userSettings) sessionVariables;
    shellAliases = {
      g = "git";
      gg = "git status -s";
      ggg = "git status";
      gd = "git diff";
      gs = "git checkout";
      ga = "git add";
      gA = "git add -A";
      gc = "git commit";
      gcaa = "git add -A && git commit";
      gca = "git commit --amend --no-edit";
      gC = "git add -A && git commit --amend --no-edit";
      gB = "git checkout -b";
      gp = "git pull";
      gP = "git push origin";
      gPF = "git push --force-with-lease";
      gPU = "git push --set-upstream";
      lg = "lazygit";
      v = "$EDITOR";
      ls = "eza --icons=always";
      la = "ls -aa";
      ll = "ls -l";
      lla = "ls -la";
      lt = "eza --tree";
      cp = "cp -i";
      rm = "rm -i";
      mv = "mv -i";
      mkdir = "mkdir -p";
      m = "make";
      mw = "make -C $HOME/work";
      hm = "home-manager --extra-experimental-features nix-command --extra-experimental-features flakes --flake $HOME/dots";
      rip_nvim = "rm -fr $HOME/.local/share/nvim/ $HOME/.local/state/nvim $HOME/.cache/nvim $HOME/dots/nvim/lazy-lock.json";
    };
  };
  manual = {
    html.enable = true;
    manpages.enable = true;
  };
  nix = {
    package = pkgs.nix;
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
      build-users-group = nixbld

      trusted-public-keys = nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM=
      trusted-substituters = https://nix-community.cachix.org https://cache.nixos.org https://cache.cachix.org
      trusted-users = tommy
    '';
  };
  programs = {
    home-manager.enable = true;
    bat.enable = true;
    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      silent = true;
    };
    eza = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
    fastfetch = {
      enable = true;
      settings.modules = [
        "title"
        "separator"
        "os"
        "kernel"
        "packages"
        "shell"
        "wm"
        "theme"
        "cpu"
        "gpu"
        "memory"
        "break"
      ];
    };
    fd.enable = true;
    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
    git = {
      enable = true;
      delta = {
        enable = true;
        options = {
          line-numbers = true;
          true-color = "always";
        };
      };
      extraConfig = {
        core = {
          editor = "nvim -c 'startinsert'";
        };
        pull.rebase = true;
        push = {
          autoSetupRemote = true;
          default = "simple";
        };
        rerere.enabled = true;
        user = {
          name = "Tommy Breslein";
          email = "tommy.breslein@protonmail.com";
        };
      };
      includes = [
        {
          condition = "gitdir:${config.home.homeDirectory}/work/";
          contents.user.email = "tommy.breslein@pailot.com";
        }
      ];
    };
    htop.enable = true;
    lazygit.enable = true;
    less.enable = true;
    man.enable = true;
    ripgrep.enable = true;
    tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };
    zsh = {
      enable = true;
      dotDir = "${config.home.homeDirectory}/.config/zsh";
      # envExtra =
      #   /*
      #   sh
      #   */
      #   ''
      #     export ZDOTDIR="${config.home.homeDirectory}/.config/zsh/"
      #   '';
      history = {
        ignoreAllDups = true;
        ignoreSpace = true;
        save = 10000;
        share = true;
        size = 20000;
      };
      initExtraFirst =
        /*
        sh
        */
        ''
          setopt menucomplete extended_glob nomatch interactivecomments
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
              make toggle_moco
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
          gco() {
              my_branch=$(git branch -a --no-color | sort | uniq | tr -d " " | fzf --select-1 --ansi --preview 'git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" {} 2>/dev/null')
              if echo $my_branch | grep -q "remotes/origin"; then
                  my_branch=\$\{my_branch##remotes/origin/}
              fi
              if echo "$my_branch" | grep -q -P --regexp='\*'; then
                  my_branch=\$\{my_branch##\*}
              fi

              git checkout $my_branch
          }

          #eval "$(fzf --zsh)"
          #export DIRENV_LOG_FORMAT=
          #eval "$(direnv hook zsh)"
          #eval "$(zoxide init zsh)"
          #eval "$(starship init zsh)"
        '';
      profileExtra =
        /*
        sh
        */
        ''
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
        '';
      plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.7.0";
            # sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
          };
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "v0.8.0";
            # sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
          };
        }
        {
          name = "zsh-completions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-completions";
            rev = "v0.35.0";
            # sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
          };
        }
      ];
    };
  };
}
