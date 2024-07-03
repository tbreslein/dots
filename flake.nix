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
          ./modules/darwin.nix
          ./modules/linux.nix
          ./modules/desktop.nix
          ./modules/laptop.nix
          ./modules/gaming.nix
          ./modules/wayland.nix
          ./modules/coding.nix

          # host specific config
          hostModule
        ];

        extraSpecialArgs = {
          inherit inputs system userSettings pkgs-stable;
        };
      };

    # ROLES="darwin linux desktop wayland code gaming laptop"
    userSettings = {
      userName = "tommy";
    };

    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-darwin"
      ] (system: function nixpkgs.legacyPackages.${system});
  in {
    homeConfigurations = {
      "${userSettings.userName}" = mkHomeConfig ./hosts/mpb.nix "aarch64-darwin";
      "${userSettings.userName}@moebius" = mkHomeConfig ./hosts/moebius.nix "x86_64-linux";
      "${userSettings.userName}@audron" = mkHomeConfig ./hosts/audron.nix "x86_64-linux";
    };

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
