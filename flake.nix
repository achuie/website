{
  description = "Use Pollen Racket to generate static site";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/22.11";
    dream2nix.url = "github:nix-community/dream2nix";
    dream2nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, dream2nix }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      apps = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in
        {
          thumbnails = {
            type = "app";
            program = "${pkgs.writeShellScriptBin "manageThumbnails.sh" ''
              for pic in $(ls ./images/portfolio); do
                if [ -f ./images/thumbnails/$pic ]; then
                  echo "  Found thumbnail for $pic"
                else
                  echo "  Generating thumbnail for $pic"
                  ${pkgs.imagemagick}/bin/magick ./images/portfolio/$pic -resize 1000000@ ./images/thumbnails/$pic
                fi
              done
              for thumbnail in $(ls ./images/thumbnails); do
                if [ ! -f ./images/portfolio/$pic ]; then
                  echo "  Removing thumbnail $pic"
                  rm ./images/thumbnails/$pic
                fi
              done
            ''}/bin/manageThumbnails.sh";
          };
        });
      devShells = forAllSystems (system:
        let
          dependencies = (dream2nix.lib.makeFlakeOutputs {
            systems = [ "x86_64-linux" ];
            config.projectRoot = ./.;
            source = ./.;
            projects = {
              site = {
                name = "site";
                subsystem = "racket";
                translator = "racket-impure";
              };
            };
          }).packages.${system};
        in
        {
          default = nixpkgsFor.${system}.mkShell {
            packages = [ dependencies.site ];
          };
        });

      formatter = forAllSystems (system: nixpkgsFor.${system}.nixpkgs-fmt);
    };
}
