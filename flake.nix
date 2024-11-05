{
  description = "https://github.com/NixOS/nixpkgs/issues/353059";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [docker-compose];
        shellHook = ''
          export DOCKER_HOST=unix:///var/run/docker.sock
        '';
      };
    });
}
