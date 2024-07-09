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
  };
}
