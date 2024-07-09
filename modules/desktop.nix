{
  config,
  lib,
  userSettings,
  ...
}: let
  cfg = config.desktop;
in {
  options = {
    desktop = {
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
        inherit (userSettings) colors;
      };
    };
  };
}
