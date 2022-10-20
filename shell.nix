{ pkgs ? import <nixpkgs> {} }:

let
  racket2nix = builtins.fetchGit {
    url = "https://github.com/achuie/racket2nix";
    ref = "master";
    rev = "3b8a03cd38cea86591a0884d267f46c1a7f475f9";
  };
in pkgs.mkShell {
  nativeBuildInputs = [ (import racket2nix { package = "pollen"; }).lib ];
}
