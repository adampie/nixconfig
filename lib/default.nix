{ lib }:

{
  # Helper function to create a Darwin system configuration
  mkDarwinSystem = {
    hostname,
    system,
    inputs,
    unstablepkgs,
    home-manager,
  }:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit inputs unstablepkgs;
      };
      modules = [
        ../hosts/darwin/${hostname}.nix
        home-manager.darwinModules.home-manager
        {
          nixpkgs.config.allowUnfree = true;
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit unstablepkgs;
            };
          };
        }
      ];
    };

  # Helper function to iterate over supported systems
  forEachSupportedSystem = {
    supportedSystems,
    nixpkgs,
    nixpkgs-unstable,
  }: f:
    lib.genAttrs supportedSystems (system:
      f {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        unstablepkgs = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      });
}
