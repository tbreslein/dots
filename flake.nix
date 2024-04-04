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
          dotsPython = pkgs.python312;
          dotsPythonPackages = pkgs.python312Packages;
          buildInputs = with pkgs; [
            dotsPython
            dotsPythonPackages.black
            dotsPythonPackages.typer
            dotsPythonPackages.python-dotenv
            bash
            git
            stow
          ];

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

          buildDotEnv = ''
            cat <<EOF > .env
            UNAME_S="${
              if system == "aarch64-darwin" then "Darwin" else "Linux"
            }"
            _HOST="${hostname}"
            ROLES="${roles}"
            ALLOWED_HOSTS="darwin moebius audron moebius-win vorador"
            REPOS="${repos}"
            COLOURS="catppuccin"
            EOF
          '';
        in {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs;
              [ nodePackages.pyright ruff ] ++ buildInputs;

            # shellHook = ''
            # '';
          };
          packages.dm = pkgs.stdenv.mkDerivation {
            name = "dm";
            inherit buildInputs;
            src = ./.;
            buildPhase = buildDotEnv;
            installPhase = ''
              mkdir -p $out/bin
              cp ./scripts/dm/* $out/bin/
              mv $out/bin/dm.py $out/bin/dm
              cp .env $out/bin/.env
            '';
          };
          packages.bootstrap = pkgs.stdenv.mkDerivation {
            name = "bootstrap";
            inherit buildInputs;
            src = ./.;
            buildPhase = buildDotEnv;
            installPhase = ''
              mkdir -p $out/bin
              cp ./scripts/bootstrap/* $out/bin/
              cp .env $out/bin/.env
            '';
          };
        };
    };
}
