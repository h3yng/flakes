{
  description = "AUR packaging environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = f:
        nixpkgs.lib.genAttrs systems
          (system: f {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = false;
            };
          });
    in
    {
      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            git
            openssh

            # packaging tooling
            pacman
            pacman-contrib
            namcap

            # common helpers
            gnupg
            curl
            wget
            unzip
            zip
            gnutar
            gzip
            xz
          ];

          shellHook = ''
            echo "Useful commands:"
            echo "  makepkg --printsrcinfo > .SRCINFO"
            echo "  namcap PKGBUILD"
            echo "  makepkg -si"
          '';
        };
      });
    };
}
