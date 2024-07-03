{
  description = "my dots";

  inputs = {
    # Principle inputs
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/24.05";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, ...}: let
    userSettings = {
      userName = "tommy";
    };
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-darwin"];
      # imports = [
      #   ./users
      #   ./home
      #   ./nixos
      #   ./nix-darwin
      # ];

      flake = {
        homeConfigurations = {
          "${userSettings.userName}@tommys_mbp" = {
            pkgs = import inputs.nixpkgs {system = "aarch64-darwin";};
          };
        };
      };

      perSystem = {
        self',
        inputs',
        pkgs,
        system,
        config,
        ...
      }: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nil
            statix
            alejandra
          ];
        };
      };
    };
}
