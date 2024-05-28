{
  description = "dots";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {self, ...}:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];

      perSystem = {
        system,
        pkgs,
        lib,
        ...
      }: let
        buildInputs = with pkgs; [bash zsh];

        hostname =
          if system == "aarch64-darwin"
          then "darwin"
          else builtins.readFile /etc/hostname;

        prePatch = ''
          cat <<EOF > .env
          UNAME_S="${
            if system == "aarch64-darwin"
            then "Darwin"
            else "Linux"
          }"

          _HOST="${hostname}"

          ROLES="${
            if system == "aarch64-darwin"
            then "desktop code"
            else if hostname == "vorador"
            then "linux rbpi"
            else if hostname == "moebius"
            then "linux desktop x11 code gaming"
            else if hostname == "audron"
            then "linux desktop x11 laptop code"
            else if hostname == "moebius-win"
            then "linux wsl code"
            else ""
          }"

          ALLOWED_HOSTS="darwin moebius audron moebius-win vorador"

          REPOS="${
            lib.concatStringsSep " " [
              "git@github.com:tbreslein/capturedlambdav2.git"
              "git@github.com:tbreslein/frankenrepo.git"
              "git@github.com:tbreslein/hydrolzigs.git"
              "git@github.com:tbreslein/ringheap.rs.git"
            ]
          }"

          X11_WM="awesomewm"
          WAYLAND_WM="hyprland"

          COLOURS="gruvbox-material"
          EOF
        '';
        postPatch = ''
          mkdir -p $out/bin
          cp .env $out/bin/.env
        '';
      in {
        devShells.default = pkgs.mkShell {buildInputs = buildInputs ++ (with pkgs; [statix alejandra nil]);};
        packages.default = pkgs.stdenv.mkDerivation {
          name = "dm";
          src = ./.;
          inherit prePatch postPatch;
          installPhase = ''
            mkdir -p $out/bin
            cp ./progs/dm/* $out/bin/
          '';
        };
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
