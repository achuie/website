{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = [ pkgs.racket-minimal ];

  shellHook = ''
    if [ -z "$(raco pkg show | awk '/pollen/')" ]; then
      raco pkg install pollen
    else
      raco pkg update pollen
    fi
  '';
}
