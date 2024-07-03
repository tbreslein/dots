{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.roles;
in {
  options = {
    roles.enableCoding = lib.mkEnableOption "Enable coding role";
  };

  config = lib.mkIf cfg.enableCoding {
    home.packages = with pkgs; [neo-cowsay];
  };
}
