{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}: let
  cfg = config.roles;
in {
  options = {
    roles.enableCoding = lib.mkEnableOption "Enable coding role";
  };

  config = lib.mkIf cfg.enableCoding {
    home.packages = (with pkgs-stable; [tmux jq jqp cmakeMinimal]) ++ (with pkgs; [neovim]);
  };
}
