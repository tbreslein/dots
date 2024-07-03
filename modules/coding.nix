{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}: let
  cfg = config.coding;
in {
  options = {
    roles.enableCoding = lib.mkEnableOption "Enable coding role";
    coding.defaultTmuxConfig = lib.mkEnableOption "Use default tmux, instead of custom config";
  };

  config = lib.mkIf config.roles.enableCoding {
    home.packages = (with pkgs-stable; [tmux jq jqp]) ++ (with pkgs; [neovim]);
  };
}
