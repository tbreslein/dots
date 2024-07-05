{
  config,
  lib,
  pkgs,
  pkgs-stable,
  userSettings,
  ...
}: let
  cfg = config.linux;
in {
  options = {
    roles.enableLinux = lib.mkEnableOption "Enable linux role";
    # linux.defaultTmuxConfig = lib.mkEnableOption "Use default tmux, instead of custom config";
  };

  config = lib.mkIf config.roles.enableLinux {
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
  };
}
