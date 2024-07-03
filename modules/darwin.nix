{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}: let
  cfg = config.darwin;
in {
  options = {
    roles.enableDarwin = lib.mkEnableOption "Enable darwin role";
    # darwin.defaultTmuxConfig = lib.mkEnableOption "Use default tmux, instead of custom config";
  };

  # config = lib.mkIf config.roles.enableCoding {
  #   home.packages = (with pkgs-stable; [tmux jq jqp]) ++ (with pkgs; [neovim]);
  # };
}
