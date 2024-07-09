{
  config,
  lib,
  pkgs-stable,
  userSettings,
  ...
}: let
  cfg = config.myConf.linux;
in {
  options = {
    myConf.linux.enable = lib.mkEnableOption "Enable linux role";
  };

  config = lib.mkIf cfg.enable {
    home = {
      homeDirectory = "/home/${userSettings.userName}";
      packages = with pkgs-stable; [
        noto-fonts
        noto-fonts-color-emoji
        (nerdfonts.override {fonts = ["Hack"];})
      ];
    };
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = ["Noto Fonts Color Emoji"];
        monospace = ["Hack Nerd Font"];
        sansSerif = ["Noto Sans"];
        serif = ["Noto Serif"];
      };
    };
    programs = {
      imv.enable = true;
    };
    services = {
      dunst = lib.mkIf (cfg.enable && config.myConf.desktop.enable) {
        enable = true;
        settings = {
          global = {
            background = "#${userSettings.colors.primary.background}";
            foreground = "#${userSettings.colors.primary.foreground}";
            frame_color = "#${userSettings.colors.primary.accent}";
            font = "Noto Sans 11";
          };
          urgency_critical = {
            frame_color = "#${userSettings.colors.normal.red}";
          };
        };
      };
    };
  };
}
