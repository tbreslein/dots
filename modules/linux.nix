{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}: let
  cfg = config.linux;
in {
  options = {
    roles.enableLinux = lib.mkEnableOption "Enable linux role";
    # linux.defaultTmuxConfig = lib.mkEnableOption "Use default tmux, instead of custom config";
  };

  # config = lib.mkIf config.roles.enableCoding {
  #   home.packages = (with pkgs-stable; [tmux jq jqp]) ++ (with pkgs; [neovim]);
  # };
}
