{userSettings, ...}: {
  home.homeDirectory = "/Users/${userSettings.userName}";
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
  };
}
