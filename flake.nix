{
  description = "Srid's NixOS / nix-darwin configuration";

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

  outputs = inputs @ {self, ...}:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-darwin"];
      # imports = [
      #   ./users
      #   ./home
      #   ./nixos
      #   ./nix-darwin
      # ];

      flake = {
        # Configuration for my Macbook (using nix-darwin)
        # darwinConfigurations.appreciate =
        #   self.nixos-flake.lib.mkMacosSystem
        #     ./systems/darwin.nix;

        # # Hetzner dedicated
        # nixosConfigurations.immediacy =
        #   self.nixos-flake.lib.mkLinuxSystem
        #     ./systems/ax41.nix;
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
        # _module.args.pkgs = import inputs.nixpkgs {
        #   inherit system;
        # };
      };
    };
}
