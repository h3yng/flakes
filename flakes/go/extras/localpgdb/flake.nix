{
  description = "go dev env with pkgs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        devShells.default = pkgs.mkShell {
          name = "go-dev-shell";

          packages = with pkgs; [
            go
            gopls
            delve

            #db
            postgresql_18
          ];

          shellHook = ''
            export GOPATH=$PWD/.gopath
            export GOBIN=$GOPATH/bin
            export PATH=$GOBIN:$PATH
            mkdir -p "$GOPATH"/{bin,pkg}
            # echo "go path set to $GOPATH"

            ## db related
            export PGDATA="$PWD/.pgdata"
            export PGHOST="$PGDATA"
            export PGPORT=5432
            export PGUSER=h3yng
            # export PGDATABASE=postgres
            export PGDATABASE=go_rest

          '';
        };
      }
    );
}
