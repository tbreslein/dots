{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}: let
  cfg = config.myConf.coding;
in {
  options = {
    myConf.coding = {
      enable = lib.mkEnableOption "Enable coding role";
      customTmuxConfig = lib.mkEnableOption "Use custom tmux config";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = (with pkgs-stable; [tmux jq jqp]) ++ (with pkgs; [neovim]);

    editorconfig = {
      enable = true;
      settings = {
        "*" = {
          charset = "utf-8";
          indent_size = 4;
          indent_style = "space";
          max_line_width = 80;
          trim_trailing_whitespace = true;
        };
        "*.{nix,cabal,hs,lua}" = {
          indent_size = 2;
        };
        "*.{json,js,jsx,ts,tsx,cjs,mjs}" = {
          indent_size = 2;
        };
        "*.{yml,yaml,ml,mli,hl,md,mdx,html,astro}" = {
          indent_size = 2;
        };
        "CMakeLists.txt" = {
          indent_size = 2;
        };
        "{m,M}akefile" = {
          indent_style = "tab";
        };
      };
    };
  };
}
