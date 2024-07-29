{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}: let
  cfg = config.myConf.gaming;
in {
  options = {
    cfg.enable = lib.mkEnableOption "Enable gaming role";
  };
}
