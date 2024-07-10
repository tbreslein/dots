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
      extraHyprlandConf.input.kb_options = "grp:alt_space_toggle,ctrl:nocaps";
    };
  };
}
