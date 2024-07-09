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
      waybar = {
        enable = true;
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 27;
            modules-left = ["hyprland/workspaces" "hyprland/window"];
            modules-center = ["clock"];
            modules-right = lib.mkMerge [
              ["pulseaudio"]
              (lib.mkIf config.myConf.laptop.enable ["battery"])
              ["tray"]
            ];
            "hyprland/window" = {
              format = "{}";
              rewrite = {
                "(.*) - Brave" = "Brave";
              };
              separate-outputs = true;
            };
            tray = {
              icon-size = 18;
              spacing = 15;
            };
            clock = {
              format = "{:%R}";
              interval = 30;
            };
            battery = {
              bat = "BAT0";
              states = {
                full = 90;
                good = 70;
                normal = 50;
                warning = 30;
                critical = 15;
              };
              format = "{icon}   {capacity}%";
              format-good = "{icon}   {capacity}%";
              format-full = "   {capacity}%";
              format-icons = ["" "" "" "" ""];
              interval = 30;
            };
            pulseaudio = {
              format = "{icon}  {volume}%  ";
              format-bluetooth = "  {volume}%  ";
              format-muted = "婢  Mute  ";
              interval = 60;
              format-icons = {
                default = [""];
              };
            };
          };
        };
        style =
          /*
          css
          */
          ''
            * {
              font-family: "Hack Nerd Font";
              font-size: 16px;
            }

            window#waybar {
              background-color: #1d2021;
              color: #d4be98;
            }

            #workspaces {
            }

            #workspaces button {
              padding: 0px 11px 0px 11px;
              min-width: 1px;
              color: #888888;
            }

            #workspaces button.active {
              padding: 0px 11px 0px 11px;
              background-color: #32302f;
              color: #d8a657;
            }

            #window {
              color: #d4be98;
              padding: 0px 10px 0px 10px;
            }

            window#waybar.empty #window {
              background-color: transparent;
              color: transparent;
            }

            window#waybar.empty {
              background-color: #323232;
            }

            #network,
            #temperature,
            #backlight,
            #pulseaudio,
            #battery {
              padding: 0px 15px 0px 15px;
            }

            #clock {
              margin: 0px 15px 0px 15px;
            }

            #tray {
              padding: 0px 8px 0px 5px;
              margin: 0px 5px 0px 5px;
            }

            #battery.critical {
              color: #ff5555;
            }

            #network.disconnected {
              color: #ff5555;
            }
          '';
      };
    };
    services = {
      hypridle = {
        enable = true;
        settings = {
          listener = [
            {
              timeout = 60;
              on-timeout = "brightnessctl -s && brightnessctl s 10%";
              on-resume = "brightnessctl -r";
            }
            {
              timeout = 300;
              on-timeout = "hyprlock";
              on-resume = "notify-send \"hi there\"";
            }
            {
              timeout = 900;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
      hyprpaper = {
        enable = true;
        settings = {
          preload = ["${config.home.homeDirectory}/wallpapers/gruvbox/wallhaven-7p6g99.png"];
          wallpaper = [",${config.home.homeDirectory}/wallpapers/gruvbox/wallhaven-7p6g99.png"];
          ipc = "off";
          splash = false;
        };
      };
    };
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {};
    };
  };
}
