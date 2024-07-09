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
    programs = {
      bemenu = {
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
      hyprlock = {
        enable = true;
        settings = {
          background = [
            {
              path = "${config.home.homeDirectory}/wallpapers/gruvbox/wallhaven-7p6g99.png";
              blur_passes = 3;
              contrast = 0.8916;
              brightness = 0.8172;
              vibrancy = 0.1696;
              vibrancy_darkness = 0.0;
            }
          ];
          general = {
            no_fade_in = false;
            grace = 0;
            disable_loading_bar = true;
          };
          input-field = [
            {
              size = "250, 60";
              outline_thickness = 2;
              dots_size = 0.2;
              dots_spacing = 0.2;
              dots_center = true;
              outer_color = "rgba(0, 0, 0, 0)";
              inner_color = "rgba(0, 0, 0, 0.5)";
              font_color = "rgba(200, 200, 200)";
              fade_on_empty = false;
              font_family = "Hack Nerd Font";
              placeholder_text = "'\'<i><span foreground=\"##cdd6f4\">Input Password...</span></i>'\'";
              shadow_passes = 2;
            }
          ];
        };
      };
    };
  };
}
