{
  config,
  pkgs,
  userSettings,
  ...
}: {
  home.username = "${userSettings.userName}";
  home.homeDirectory = "/Users/tommy";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
