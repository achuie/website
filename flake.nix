{
  description = "Use Pollen Racket to generate static site";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    dream2nix = {
      url = "github:nix-community/dream2nix?ref=legacy";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, dream2nix }:
    let
      forAllSystems = f: nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system:
        f nixpkgs.legacyPackages.${system});

      project-outputs = dream2nix.lib.makeFlakeOutputs {
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
      };
    in
    {
      apps = forAllSystems (pkgs:
        {
          thumbnails = {
            type = "app";
            program = "${pkgs.writeShellScriptBin "manageThumbnails.sh" ''
              for pic in $(ls ./images/portfolio); do
                if [ -f ./images/thumbnails/$pic ]; then
                  echo "  Found thumbnail for $pic"
                else
                  echo "    Generating thumbnail for $pic"
                  ${pkgs.imagemagick}/bin/magick ./images/portfolio/$pic -resize 1000000@ ./images/thumbnails/$pic
                fi
              done
              for thumbnail in $(ls ./images/thumbnails); do
                if [ ! -f ./images/portfolio/$thumbnail ]; then
                  echo "  Removing thumbnail for $thumbnail"
                  rm ./images/thumbnails/$thumbnail
                fi
              done
            ''}/bin/manageThumbnails.sh";
          };
        });

      packages = forAllSystems (pkgs:
        {
          default = pkgs.stdenv.mkDerivation {
            pname = "site";
            version = "0.1.0";

            src = ./.;
            buildInputs = [ project-outputs.packages.${pkgs.system}.site pkgs.exif ];
            buildPhase = ''
              ${self.apps.${pkgs.system}.thumbnails.program}
              raco pollen publish . $out
            '';
          };

          resolveImpure = project-outputs.packages.${pkgs.system}.site.resolve;
        });

      devShells = forAllSystems (pkgs:
        {
          default = pkgs.mkShell {
            packages = [ project-outputs.packages.${pkgs.system}.site pkgs.exif ];
          };
        });
    };
}
