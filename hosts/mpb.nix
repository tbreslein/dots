{userSettings, ...}: {
  home.homeDirectory = "/Users/${userSettings.userName}";
  roles.enableCoding = true;
}
