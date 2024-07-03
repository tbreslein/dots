{userSettings, ...}: {
  home = {
    username = "${userSettings.userName}";
    homeDirectory = "/Users/tommy";
    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;
}
