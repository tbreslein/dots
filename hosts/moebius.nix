{userSettings, ...}: {
  home.homeDirectory = "/home/${userSettings.userName}";
  targets.genericLinux.enable = true;
  myConf = {
    coding = {
      enable = true;
      customTmuxConfig = true;
    };
    desktop = {
      enable = true;
      terminal = {
        fontSize = 15;
        windowOpacity = 0.6;
      };
    };
    linux.enable = true;
    wayland = {
      enable = true;
      extraHyprlandConf = {
        input.kb_options = "grp:alt_space_toggle";
        monitor = ["DP-1,3840x2160@144,0x0,1.5"];
      };
    };
    home.repos = [
      {
        remote = "git@github.com:tbreslein/ringheap.rs.git";
        target = "code/ringheap.rs";
      }
      {
        remote = "git@github.com:tbreslein/capturedlambdav2.git";
        target = "code/capturedlambdav2";
      }
      {
        remote = "git@github.com:tbreslein/shyr.git";
        target = "code/shyr";
      }
      {
        remote = "git@github.com:tbreslein/sest.git";
        target = "code/sest";
      }
      {
        remote = "git@github.com:tbreslein/yunix.git";
        target = "code/yunix";
      }
    ];
  };
}
