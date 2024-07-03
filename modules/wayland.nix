{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}: let
  cfg = config.wayland;
in {
  options = {
    roles.enableWayland = lib.mkEnableOption "Enable wayland role";
    wayland.defaultTmuxConfig = lib.mkEnableOption "Use default tmux, instead of custom config";
  };

  # config = lib.mkIf config.roles.enableCoding {
  #   home.packages = (with pkgs-stable; [tmux jq jqp]) ++ (with pkgs; [neovim]);
  # };
}
