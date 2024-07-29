{
  config,
  lib,
  userSettings,
  ...
}: let
  cfg = config.myConf.desktop;
in {
  options = {
    myConf.desktop = {
      enable = lib.mkEnableOption "Enable desktop role";
      terminal = {
        fontSize = lib.mkOption {
          default = 15;
          type = lib.types.int;
        };
        windowOpacity = lib.mkOption {
          default = 0.9;
          type = lib.types.float;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.file.".config/alacritty/alacritty.toml".text =
      /*
      toml
      */
      ''
        [colors.primary]
        background = "#${userSettings.colors.primary.background}"
        foreground = "#${userSettings.colors.primary.foreground}"

        [colors.normal]
        black = "#${userSettings.colors.normal.black}"
        red = "#${userSettings.colors.normal.red}"
        green = "#${userSettings.colors.normal.green}"
        yellow = "#${userSettings.colors.normal.yellow}"
        blue = "#${userSettings.colors.normal.blue}"
        magenta = "#${userSettings.colors.normal.magenta}"
        cyan = "#${userSettings.colors.normal.cyan}"
        white = "#${userSettings.colors.normal.white}"

        [cursor.style]
        blinking = "Never"
        shape = "Block"

        [font]
        size = ${toString cfg.terminal.fontSize}
        [font.normal]
        family = "Hack Nerd Font"

        [window]
        blur = true
        decorations = "Buttonless"
        dynamic_padding = true
        opacity = ${toString cfg.terminal.windowOpacity}
        option_as_alt = "OnlyLeft"
      '';
    programs = {
      starship = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        settings = {
          format = "$battery$directory$nix_shell$vcsh$fossil_branch$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$line_break$character";
          command_timeout = 2000;
          character = {
            error_symbol = "[λ](bold red)";
            success_symbol = "[λ](bold yellow)";
            vicmd_symbol = "[λ](bold green)";
          };
          directory = {
            style = "bold blue";
            truncate_to_repo = true;
            truncation_symbol = ".../";
          };
          nix_shell.format = "[$symbol]($style)";
        };
      };
      yazi = {
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };
      zoxide = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };
    };
  };
}
