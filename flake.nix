{
  description = "A basic rust flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs
    , flake-utils
    , fenix
    , ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        rustVersion = fenix.packages.${system}.stable;
        rust = rustVersion.withComponents [
          "cargo"
          "rust-src"
          "rustc"
          "rust-analyzer"
        ];
      in
      with pkgs; {
        devShells.default =
          mkShell
            {
              buildInputs = [ rust ];
            };
      }
    );
}
