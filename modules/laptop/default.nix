{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}: let
  cfg = config.myConf.laptop;
in {
  options = {
    cfg.enable = lib.mkEnableOption "Enable laptop role";
  };
}
