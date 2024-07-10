{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}: let
  cfg = config.myConf.coding;
  tmux_sessionizer =
    pkgs.writeShellScriptBin "tmux-sessionizer"
    /*
    bash
    */
    ''
      folders=("$HOME")
      add_dir() {
          [ -d "$HOME/$1" ] && folders+=("$HOME/$1")
      }

      add_dir "code"
      add_dir "notes"
      add_dir "work"
      add_dir "work/repos"

      if [[ $# -eq 1 ]]; then
          selected=$1
      else
          selected=$(find $(echo "''${folders[@]}") -mindepth 1 -maxdepth 1 -type d | fzf)
      fi

      if [[ -z $selected ]]; then
          exit 0
      fi

      selected_name=$(basename "$selected" | tr . _)
      tmux_running=$(pgrep tmux)

      if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
          tmux new-session -s "$selected_name" -c "$selected"
          exit 0
      fi

      if ! tmux has-session -t="$selected_name" 2>/dev/null; then
          tmux new-session -ds "$selected_name" -c "$selected"
      fi

      tmux switch-client -t "$selected_name"
    '';
in {
  options = {
    myConf.coding = {
      enable = lib.mkEnableOption "Enable coding role";
      customTmuxConfig = lib.mkEnableOption "Use custom tmux config";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [pkgs-stable.jqp pkgs.neovim tmux_sessionizer];
      file.".luacheckrc" = {
        text = ''
          globals = { "vim", "LAZY_PLUGIN_SPEC", "spec", "kmap" }
        '';
      };
      activation = {
        updateNvim =
          lib.hm.dag.entryAfter ["writeBoundary"]
          /*
          bash
          */
          ''
            if [ ! -d ${config.home.homeDirectory}/.config/nvim ]; then
              ln -s "${config.home.homeDirectory}/dots/nvim" "${config.home.homeDirectory}/.config/"
            else
              nvim --headless \
                -c "MasonUpdate" \
                -c "MasonToolsUpdateSync" \
                -c "Lazy! sync" \
                -c "TSUpdateSync" \
                -c "qa"
            fi
          '';
      };
    };

    editorconfig = {
      enable = true;
      settings = {
        "*" = {
          charset = "utf-8";
          indent_size = 4;
          indent_style = "space";
          max_line_width = 80;
          trim_trailing_whitespace = true;
        };
        "*.{nix,cabal,hs,lua}" = {
          indent_size = 2;
        };
        "*.{json,js,jsx,ts,tsx,cjs,mjs}" = {
          indent_size = 2;
        };
        "*.{yml,yaml,ml,mli,hl,md,mdx,html,astro}" = {
          indent_size = 2;
        };
        "CMakeLists.txt" = {
          indent_size = 2;
        };
        "{m,M}akefile" = {
          indent_style = "tab";
        };
      };
    };
    programs = {
      jq.enable = true;
      tmux = lib.mkMerge [
        {
          enable = true;
        }
        (lib.mkIf
          cfg.customTmuxConfig {
            baseIndex = 1;
            clock24 = true;
            escapeTime = 0;
            historyLimit = 25000;
            keyMode = "vi";
            mouse = true;
            prefix = "C-a";
            extraConfig =
              /*
              tmux
              */
              ''
                set -g default-terminal "alacritty"
                set-option -sa terminal-overrides ",alacritty:RGB"

                # >>> STYLE
                set -g status-position top
                setw -g mode-style 'fg=colour3 bg=colour0 bold'

                # pane borders
                set -g pane-border-style 'fg=colour0'
                set -g pane-active-border-style 'fg=colour3'

                # statusbar
                set -g status-justify left
                set -g status-style 'fg=colour4 bg=colour0 bold'
                set -g status-left ""
                set -g status-right 'Session: #S '
                set -g status-right-length 50
                set -g status-left-length 10

                setw -g window-status-current-style 'fg=colour3 bg=colour0 bold'
                setw -g window-status-current-format ' #I #W #F '

                setw -g window-status-style 'fg=colour1 dim'
                setw -g window-status-format ' #I #[fg=colour7]#W #[fg=colour1]#F '

                setw -g window-status-bell-style 'fg=colour2 bg=colour1 bold'

                # messages
                set -g message-style 'fg=colour2 bg=colour0 bold'

                bind-key -r f run-shell "tmux new-window ${tmux_sessionizer}/bin/tmux-sessionizer"

                bind C-x split-window -v -c "#{pane_current_path}"
                bind C-v split-window -hb -c "#{pane_current_path}"
                bind h select-pane -L
                bind j select-pane -D
                bind k select-pane -U
                bind l select-pane -R
                bind -r M-h resize-pane -L 1
                bind -r M-j resize-pane -D 1
                bind -r M-k resize-pane -U 1
                bind -r M-l resize-pane -R 1
                bind C-r source-file ~/.config/tmux/tmux.conf
                bind -r C-n previous-window
                bind -r C-m next-window
              '';
          })
      ];
    };
  };
}
