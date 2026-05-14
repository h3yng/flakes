{
  description = "Web development template (Node.js, npm, pnpm, bun, yarn)";

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
            nodejs_22
            bun
            pnpm
            yarn
            git
          ];

          shellHook = ''
            export PNPM_HOME="$PWD/.pnpm"
            export NPM_CONFIG_PREFIX="$PWD/.npm-global"
            export PATH="$PNPM_HOME:$NPM_CONFIG_PREFIX/bin:$PATH"
            mkdir -p "$PNPM_HOME" "$NPM_CONFIG_PREFIX"
            corepack enable >/dev/null 2>&1 || true
          '';
        };

        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}