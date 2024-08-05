{
  description = "my dots";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    mkHomeConfig = hostModule: system: let
      pkgs-unstable = import inputs.nixpkgs-unstable {inherit system;};
      pkgs-stable = import inputs.nixpkgs {inherit system;};
    in
      home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs-unstable;
        modules = [
          # shared defaults
          ./hosts/home.nix

          # modules exposing options
          ./modules/darwin
          ./modules/linux
          ./modules/desktop
          ./modules/laptop
          ./modules/gaming
          ./modules/wayland
          ./modules/coding

          # host specific config
          hostModule
        ];

        extraSpecialArgs = {
          inherit inputs system userSettings pkgs-stable;
        };
      };

    # ROLES="darwin linux desktop wayland code gaming laptop"
    userSettings = rec {
      userName = "tommy";
      sessionPath = [
        "$HOME/bin"
        "$HOME/.local/bin"
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
      ];
      sessionVariables = rec {
        EDITOR = "nvim";
        VISUAL = EDITOR;
        BROWSER = "brave";
      };
      colors = vague;
      gruvbox-material = {
        primary = {
          background = "1d2021";
          foreground = "d4be98";
          accent = "d8a657";
        };
        normal = {
          black = "32302f";
          red = "ea6962";
          green = "a9b665";
          yellow = "d8a657";
          blue = "7daea3";
          magenta = "d3869b";
          cyan = "89b482";
          white = "d4be98";
        };
        bright = {
          black = "32302f";
          red = "ea6962";
          green = "a9b665";
          yellow = "d8a657";
          blue = "7daea3";
          magenta = "d3869b";
          cyan = "89b482";
          white = "d4be98";
        };
        dim = {
          black = "32302f";
          red = "ea6962";
          green = "a9b665";
          yellow = "d8a657";
          blue = "7daea3";
          magenta = "d3869b";
          cyan = "89b482";
          white = "d4be98";
        };
      };
      vague = {
        primary = {
          background = "18191a";
          foreground = "cdcdcd";
          accent = "878787";
        };
        normal = {
          black = "18191a";
          red = "d2788c";
          green = "8faf77";
          yellow = "d2a374";
          blue = "7894ab";
          magenta = "b9a3ba";
          cyan = "a1b3b9";
          white = "cdcdcd";
        };
        bright = {
          black = "878787";
          red = "d2788c";
          green = "8faf77";
          yellow = "d2a374";
          blue = "7894ab";
          magenta = "b9a3ba";
          cyan = "a1b3b9";
          white = "cdcdcd";
        };
        dim = vague.normal;
      };
    };

    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-darwin"
      ] (system: function nixpkgs.legacyPackages.${system});
  in {
    homeConfigurations = {
      "${userSettings.userName}" = mkHomeConfig ./hosts/mbp.nix "aarch64-darwin";
      "${userSettings.userName}@moebius" = mkHomeConfig ./hosts/moebius.nix "x86_64-linux";
      "${userSettings.userName}@audron" = mkHomeConfig ./hosts/audron.nix "x86_64-linux";
    };

    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShell {
        packages = [
          pkgs.nil
          pkgs.statix
          pkgs.alejandra
          pkgs.luajitPackages.lua-lsp
          pkgs.stylua
          pkgs.home-manager
        ];
      };
    });
  };
}
