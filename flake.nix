{
  description = "Hy";
  inputs = {
    flake-utils.url = github:numtide/flake-utils;
    nixpkgs.url = github:NixOS/nixpkgs;
    poetry2nix.url = github:nix-community/poetry2nix;
  };
  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    with flake-utils.lib; eachSystem allSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ poetry2nix.overlay ];
        };
        poetryEnv = pkgs.poetry2nix.mkPoetryEnv {
          projectDir = ./.;
          python = pkgs.python310;
          editablePackageSources = {
            hy = ./hy;
          };
        };
      in {
        defaultApp = pkgs.hy;
        defaultPackage = pkgs.hy;
        devShell = poetryEnv.env;
      });
}
