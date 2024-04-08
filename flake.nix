{
  description = "dots";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];

      perSystem = { system, pkgs, lib, ... }:
        let
          # packages.default = pkgs.buildGoModule {
          #   pname = "frankenrepo";
          #   inherit version;
          #   src = ./.;
          #   # vendorSha256 = "0000000000000000000000000000000000000000000000000000";
          #   vendorSha256 = "3tO/+Mnvl/wpS7Ro3XDIVrlYTGVM680mcC15/7ON6qM=";
          # };
          buildInputs = with pkgs; [ go bash git stow ];

          hostname = if system == "aarch64-darwin" then
            "darwin"
          else
            builtins.readFile /etc/hostname;

          # all roles: desktop laptop linux wsl rbpi code gaming
          roles = if system == "aarch64-darwin" then
            "desktop code"
          else if hostname == "vorador" then
            "linux rbpi"
          else if hostname == "moebius" then
            "linux desktop code gaming"
          else if hostname == "audron" then
            "linux desktop laptop code"
          else if hostname == "mebius-win" then
            "linux wsl code"
          else
            "";

          repos = lib.concatStringsSep " " [
            "github.com:tbreslein/capturedlambda.git"
            "codeberg.org:tbreslein/corries.git"
            "codeberg.org:tbreslein/frankenrepo.git"
            "codeberg.org:tbreslein/hedispp.git"
            "codeberg.org:tbreslein/hydrie.git"
            "codeberg.org:tbreslein/outcome.git"
            "codeberg.org:tbreslein/ringheap.rs.git"
            "codeberg.org:tbreslein/tense.git"
          ];

          prePatch = ''
            cat <<EOF > .env
            UNAME_S="${
              if system == "aarch64-darwin" then "Darwin" else "Linux"
            }"
            _HOST="${hostname}"
            ROLES="${roles}"
            ALLOWED_HOSTS="darwin moebius audron moebius-win vorador"
            REPOS="${repos}"
            COLOURS="gruvbox-material"
            EOF
          '';
          postPatch = ''
            mkdir -p $out/bin
            cp .env $out/bin/.env
          '';
        in {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs;
              [ gopls gofumpt golangci-lint just ] ++ buildInputs;

            # GOWORK = "off";
            # shellHook = ''
            # '';
          };
          packages.default = pkgs.buildGoModule {
            pname = "dots";
            version = "0.0.1";
            src = ./.;
            inherit prePatch postPatch;
          };
          # packages.dotem = pkgs.buildGoModule {
          #   pname = "dotem";
          #   version = "0.0.1";
          #   src = ./.;
          #   modRoot = ./progs/dotem;
          #   vendorHash = null;
          #   inherit prePatch postPatch;
          # };
          # packages.dm = pkgs.stdenv.mkDerivation {
          #   name = "dm";
          #   inherit buildInputs;
          #   src = ./.;
          #   buildPhase = buildDotEnv;
          #   installPhase = ''
          #     mkdir -p $out/bin
          #     cp ./scripts/dm/* $out/bin/
          #     mv $out/bin/dm.py $out/bin/dm
          #     cp .env $out/bin/.env
          #   '';
          # };
          packages.bootstrap = pkgs.stdenv.mkDerivation {
            name = "bootstrap";
            inherit buildInputs prePatch postPatch;
            src = ./.;
            installPhase = ''
              mkdir -p $out/bin
              cp ./progs/bootstrap/* $out/bin/
            '';
          };
        };
    };
}
