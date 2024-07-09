{
  config,
  lib,
  userSettings,
  ...
}: let
  cfg = config.myConf.wayland;
in {
  options = {
    myConf.wayland = {
      enable = lib.mkEnableOption "Enable wayland role";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.bemenu = {
      enable = true;
      settings = {
        ignorecase = true;
        prompt = "";
        fn = "Hack";
        fb = "#${userSettings.colors.primary.background}";
        ff = "#${userSettings.colors.primary.foreground}";
        nb = "#${userSettings.colors.primary.background}";
        nf = "#${userSettings.colors.primary.foreground}";
        ab = "#${userSettings.colors.primary.background}";
        af = "#${userSettings.colors.primary.foreground}";
        hb = "#${userSettings.colors.primary.background}";
        hf = "#${userSettings.colors.primary.accent}";
      };
    };
  };
}
