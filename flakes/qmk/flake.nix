{
  description = "QMK keyboard firmware build template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            qmk
            git
            gnumake
            python3
            python3Packages.pip
            avr-gcc
            avr-libc
            avrdude
            dfu-programmer
            dfu-util
            arm-none-eabi-gcc
            arm-none-eabi-binutils
          ];

          shellHook = ''
            export QMK_HOME="$PWD/.qmk_firmware"
            mkdir -p "$QMK_HOME"
            export PATH="$HOME/.local/bin:$PATH"
          '';
        };

        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}