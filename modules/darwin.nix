{
  config,
  lib,
  userSettings,
  pkgs,
  pkgs-stable,
  ...
}: let
  cfg = config.myConf.darwin;
in {
  options = {
    myConf.darwin.enable = lib.mkEnableOption "Enable darwin role";
  };

  config = lib.mkIf cfg.enable {
    home.homeDirectory = "/Users/${userSettings.userName}";
  };
}
