{
  description = "Use Pollen Racket to generate static site";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    dream2nix = {
      url = "github:nix-community/dream2nix?ref=legacy";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://garage.cachix.org"
    ];
    extra-trusted-public-keys = [
      "garage.cachix.org-1:AH27ths8QR/GZlbFoCQk+Ju3R4U2XepsdQKU3LN0JDA="
    ];
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
              find ./images/portfolio -regex '.*\.\(jpg\|jxl\)' -printf '%f\n' | sort >./portfolio_files.txt
              if [ -f ./portfolio_datetimes.txt ]; then
                rm ./portfolio_datetimes.txt
              fi

              while read pic; do
                if [ -f ./images/thumbnails/$pic ]; then
                  echo "  Found thumbnail for $pic"
                else
                  echo "    Generating thumbnail for $pic"
                  ${pkgs.imagemagick}/bin/magick ./images/portfolio/$pic -resize 250000@ ./images/thumbnails/$pic
                fi

                timestamp=$(${pkgs.exif}/bin/exif -t DateTimeOriginal ./images/portfolio/$pic | grep Value | sed 's/[a-zA-Z: ]*//g')
                if [ -z $timestamp ]; then
                  timestamp="0"
                fi
                echo $timestamp >>./portfolio_datetimes.txt
              done <./portfolio_files.txt

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
        let fs = nixpkgs.lib.fileset; in {
          default = pkgs.stdenv.mkDerivation {
            pname = "site";
            version = "0.1.0";

            src = fs.toSource {
              root = ./.;
              fileset = fs.unions (map
                (ext: fs.fileFilter (file: file.hasExt ext) ./.)
                [ "p" "pp" "pm" "txt" "rkt" "css" "js" ]
              );

            };
            buildInputs = [ project-outputs.packages.${pkgs.system}.site ];
            buildPhase = ''
              raco pollen render -psf .
            '';
            installPhase = ''
              rm *.txt
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
