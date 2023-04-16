{
  description = "Use Pollen Racket to generate static site";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/22.11";
    dream2nix.url = "github:nix-community/dream2nix";
    dream2nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, dream2nix }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
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
          dependencies = dependencies;
          default = nixpkgsFor.${system}.mkShell {
            packages = [ dependencies.site ];
          };
        });

      formatter = forAllSystems (system: nixpkgsFor.${system}.nixpkgs-fmt);
    };
}
