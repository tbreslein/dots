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
      extraHyprlandConf = lib.mkOption {
        default = {};
        type = with lib.types; attrsOf inferred;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      file = {
        ".config/electron/electron-flags.conf".text = ''
          --ozone-platform-hint=auto
          --ozone-platform=wayland
          --enable-webrtc-pipewire-capturer
          --enable-features=WaylandWindowDecorations
          --gtk-version=4
        '';
        ".config/electron-flags.conf".text = ''
          --ozone-platform-hint=auto
          --enable-features=WaylandWindowDecorations
          --ozone-platform=wayland
        '';
        ".config/electron13/electron13-flags.conf".text = ''
          --ozone-platform-hint=auto
          --ozone-platform=wayland
          --enable-features=UseOzonePlatform
          --enable-features=WaylandWindowDecorations
        '';
        ".config/electron13-flags.conf".text = ''
          --ozone-platform-hint=auto
          --enable-features=WaylandWindowDecorations
          --ozone-platform=wayland
        '';

        ".config/hypr/hyprpaper.conf".text =
          /*
          hyprlang
          */
          ''
            preload = ${config.home.homeDirectory}/wallpapers/gruvbox/wallhaven-7p6g99.png
            wallpaper = ${config.home.homeDirectory}/wallpapers/gruvbox/wallhaven-7p6g99.png
            ipc = off
            splash = false
          '';
        ".config/hypr/hypridle.conf".text =
          /*
          hyprlang
          */
          ''
            listener {
              timeout = 60
              on-timeout = brightnessctl -s && brightnessctl s 10%
              on-resume = brightnessctl -r
            }
            listener {
              timeout = 300
              on-timeout = hyprlock
              on-resume = notify-send "hi there"
            }
            listener {
              timeout = 900
              on-timeout = hyprctl dispatch dpms off
              on-resume = hyprctl dispatch dpms on
            }
          '';
        ".config/hypr/hyprlock.conf".text =
          /*
          hyprlang
          */
          ''
            background {
              monitor =
              path = ${config.home.homeDirectory}/wallpapers/gruvbox/wallhaven-7p6g99.png
              blur_passes = 3
              contrast = 0.8916
              vibrancy = 0.1696
              vibrancy_darkness = 0.0
            }

            general {
              no_fade_in = false
              grace = 0
              disable_loading_bar = true
            }

            input-field {
              monitor =
              size = 250, 60
              outline_thickness = 2
              dots_size = 0.2
              dots_spacing = 0.2
              dots_center = true
              outer_color = rgba(0, 0, 0, 0)
              inner_color = rgba(0, 0, 0, 0.5)
              font_color = rgb(200, 200, 200)
              fade_on_empty = false
              font_family = Hack Nerd Font
              placeholder_text = "'\'<i><span foreground=\"##cdd6f4\">Input Password...</span></i>'\'"
              shadow_passes = 2
            }
          '';
        ".config/hypr/hyprland.conf".text =
          /*
          hyprlang
          */
          ''
            exec = wlsunset
            exec-once = waybar
            exec-once = blueman-applet
            exec-once = nm-applet
            exec-once = dunst
            exec-once = wl-paste --type text --watch cliphist store
            exec-once = wl-paste --type image --watch cliphist store
            exec-once = hyprpaper

            env = XDG_CURRENT_DESKTOP,Hyprland
            env = XDG_SESSION_TYPE,wayland
            env = XDG_SESSION_DESKTOP,Hyprland
            env = QT_QPA_PLATFORM,wayland
            # env = QT_STYLE_OVERRIDE,kvantum
            env = QT_QPA_PLATFORMTHEME,qt5ct
            env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
            env = QT_AUTO_SCREEN_SCALE_FACTOR,1
            env = MOZ_ENABLE_WAYLAND,1
            env = ELECTRON_OZONE_PLATFORM_HINT,wayland

            decoration {
              rounding = 2
            }
            general {
              border_size = 1
              col.active_border = 0xee${userSettings.colors.primary.accent}
              col.inactive_border = 0xee${userSettings.colors.bright.black}
              layout = master
            }
            input {
              follow_mouse = 0
              kb_layout = us,de
              repeat_delay = 300
              repeat_rate = 35
            }
            master {
              mfact = 0.5
              orientation = right
            }
            misc {
              disable_hyprland_logo = true
              disable_splash_rendering = true
              key_press_enables_dpms = true
              mouse_move_enables_dpms = true
            }

            windowrulev2 = float,title:^(Picture(.)in(.)picture$
            windowrulev2 = pin,title:^(Picture(.)in(.)picture)$
            windowrulev2 = float,class:^(steam)$,title:^(Friends list)$
            windowrulev2 = float,class:^(steam)$,title:^(Steam Settings)$
            windowrulev2 = workspace 3,class:^(steam)$
            windowrulev2 = workspace 3,class:^(lutris)$
            windowrulev2 = workspace 3,title:^(Wine System Tray)$
            windowrulev2 = workspace 4,class:^(battle.net.exe)$

            bind = $mod, Space, exec, bemenu-run
            bind = $mod, Return, exec, [workspace 2] alacritty
            bind = $mod, b, exec, [workspace 1] brave
            bind = $mod, q, killactive,
            bind = $mod ALT, q, exit,
            bind = $mod, f, fullscreen, 1
            bind = $mod ALT, f, fullscreen, 0
            bind = $mod ALT, v, togglefloating,
            bind = , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_SINK@ 5%+
            bind = , XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_SINK@ 5%-
            bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle
            bind = , XF86AudioPlay, exec, playerctl play-pause
            bind = , XF86AudioPrev, exec, playerctl previous
            bind = , XF86AudioNext, exec, playerctl next
            bind = $mod, p, exec, grim -g \"$(slurp)\" - | satty --filename - --copy-command wl-copy --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png
            bind = $mod ALT, p, exec, grim - | satty --filename - --copy-command wl-copy --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png
            bind = $mod, j, cyclenext,
            bind = $mod, k, cyclenext, prev
            bind = $mod CTRL, h, swapwindow, l
            bind = $mod CTRL, j, swapwindow, d
            bind = $mod CTRL, k, swapwindow, u
            bind = $mod CTRL, l, swapwindow, r
            bind = $mod, Tab, cyclenext,
            bind = $mod, Tab, bringactivetotop,
            bind = $mod ALT, h, resizeactive, -10,0
            bind = $mod ALT, j, resizeactive, 0,10
            bind = $mod ALT, k, resizeactive, ,-10
            bind = $mod ALT, l, resizeactive, 10,0
            bind = $mod, 1, workspace, 1
            bind = $mod, 2, workspace, 2
            bind = $mod, 3, workspace, 3
            bind = $mod, 4, workspace, 4
            bind = $mod, 5, workspace, 5
            bind = $mod CTRL, 1, movetoworkspace, 1
            bind = $mod CTRL, 2, movetoworkspace, 2
            bind = $mod CTRL, 3, movetoworkspace, 3
            bind = $mod CTRL, 4, movetoworkspace, 4
            bind = $mod CTRL, 5, movetoworkspace, 5
            bind = $mod, n, workspace, -1
            bind = $mod, m, workspace, +1
            bind = $mod CTRL, n, movetoworkspace, -1
            bind = $mod CTRL, m, movetoworkspace, +1

            bindel = , XF86MonBrightnessUp, exec, brightnessctl set +5%
            bindel = , XF86MonBrightnessDown, exec, brightnessctl set 5%-

            bindm = $mod, mouse:272, movewindow
            bindm = $mod, mouse:273, resizewindow

            $mod = SUPER
          '';

        ".config/waybar/config.jsonc".text =
          /*
          json
          */
          ''
            {
              "mainBar": {
                "layer": "top",
                "height": 27,
                "modules-left": ["hyprland/workspaces", "hyprland/window"],
                "modules-center": ["clock"],
                "modules-right": ["pulseaudio", "battery", "tray"],
                "hyprland/window": {
                  "format": "{}",
                  "rewrite": {
                    "(.*) - Brave": "Brave"
                  },
                  "separate-outputs": true
                },
                "tray": {
                  "icon-size": 18,
                  "spacing": 15
                },
                "clock": {
                  "format": "{:%R}",
                  "interval": 30
                },
                "battery": {
                  "bat": "BAT0";
                  "states": {
                    "full": 90,
                    "good": 70,
                    "normal": 50,
                    "warning": 30,
                    "critical": 15,
                    "format": "{icon}   {capacity}%",
                    "format-good": "{icon}   {capacity}%",
                    "format-full": "   {capacity}%",
                    "format-icons": ["" "" "" "" ""],
                    "interval": 30
                  },
                },
                "pulseaudio": {
                  "format": "{icon}  {volume}%  ",
                  "format-bluetooth": "  {volume}%  ",
                  "format-muted": "婢  Mute  ",
                  "interval": 60,
                  "format-icons": {
                    "default": [""],
                  }
                }
              }
            }
          '';
        ".config/waybar/style.css".text =
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
      sessionVariables = {
        BEMENU_OPTS = "-i -p \"\" --fn Hack --fb \"##${userSettings.colors.primary.background}\" --ff \"##${userSettings.colors.primary.foreground}\" --nb \"##${userSettings.colors.primary.background}\" --nf \"##${userSettings.colors.primary.foreground}\" --ab \"##${userSettings.colors.primary.background}\" --af \"##${userSettings.colors.primary.foreground}\" --hb \"##${userSettings.colors.primary.background}\" --hf \"##${userSettings.colors.primary.accent}\"";
      };
    };
  };
}
