{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}: let
  cfg = config.gaming;
in {
  options = {
    roles.enableGaming = lib.mkEnableOption "Enable gaming role";
    gaming.defaultTmuxConfig = lib.mkEnableOption "Use default tmux, instead of custom config";
  };

  # config = lib.mkIf config.roles.enableCoding {
  #   home.packages = (with pkgs-stable; [tmux jq jqp]) ++ (with pkgs; [neovim]);
  # };
}
