{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}: let
  cfg = config.laptop;
in {
  options = {
    roles.enableLaptop = lib.mkEnableOption "Enable laptop role";
    # laptop.defaultTmuxConfig = lib.mkEnableOption "Use default tmux, instead of custom config";
  };

  # config = lib.mkIf config.roles.enableCoding {
  #   home.packages = (with pkgs-stable; [tmux jq jqp]) ++ (with pkgs; [neovim]);
  # };
}
