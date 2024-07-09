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
    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          normal.family = "Hack Nerd Font";
          size = cfg.terminal.fontSize;
        };
        cursor.style = {
          blinking = "Never";
          shape = "Block";
        };
        window = {
          blur = true;
          decorations = "Buttonless";
          dynamic_padding = true;
          option_as_alt = "OnlyLeft";
          opacity = cfg.terminal.windowOpacity;
        };
        colors = {
          primary = {
            background = "#${userSettings.colors.primary.background}";
            foreground = "#${userSettings.colors.primary.foreground}";
          };
          normal = {
            black = "#${userSettings.colors.normal.black}";
            red = "#${userSettings.colors.normal.red}";
            green = "#${userSettings.colors.normal.green}";
            yellow = "#${userSettings.colors.normal.yellow}";
            blue = "#${userSettings.colors.normal.blue}";
            magenta = "#${userSettings.colors.normal.magenta}";
            cyan = "#${userSettings.colors.normal.cyan}";
            white = "#${userSettings.colors.normal.white}";
          };
        };
      };
    };
  };
}
