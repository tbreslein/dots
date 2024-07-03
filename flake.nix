{
  description = "my dots";

  inputs = {
    nixpkgs.url = "nixpkgs";
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
    mkHomeConfig = machineModule: system:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
        };

        modules = [
          ./hosts/home.nix
          ./modules/default.nix
          machineModule
        ];

        extraSpecialArgs = {
          inherit inputs system userSettings;
        };
      };

    userSettings = {
      userName = "tommy";
    };

    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-darwin"
      ] (system: function nixpkgs.legacyPackages.${system});
  in {
    homeConfigurations."${userSettings.userName}" = mkHomeConfig ./hosts/mpb.nix "aarch64-darwin";
    # homeConfigurations."${userSettings.userName}@moebius" = mkHomeConfig ./machine/laptop.nix "x86_64-linux";
    # homeConfigurations."${userSettings.userName}@audron" = mkHomeConfig ./machine/work.nix "x86_64-linux";

    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShell {
        packages = [
          pkgs.nil
          pkgs.statix
          pkgs.alejandra
          pkgs.home-manager
        ];
      };
    });
  };
}
