{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}: let
  cfg = config.desktop;
in {
  options = {
    roles.enableDesktop = lib.mkEnableOption "Enable desktop role";
    # desktop.defaultTmuxConfig = lib.mkEnableOption "Use default tmux, instead of custom config";
  };

  # config = lib.mkIf config.roles.enableCoding {
  #   home.packages = (with pkgs-stable; [tmux jq jqp]) ++ (with pkgs; [neovim]);
  # };
}
