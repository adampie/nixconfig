{
  description = "Nix config by adampie";

  inputs = {
    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/*";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    nixpkgs-unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";

    nix-darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    flake-schemas,
    nixpkgs,
    nixpkgs-unstable,
    nix-darwin,
    home-manager,
    ...
  } @ inputs: let
    supportedSystems = ["aarch64-darwin"];

    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
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

    mkDarwinSystem = hostname: system: let
      unstablepkgs = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
      nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {
          inherit inputs unstablepkgs;
        };
        modules = [
          ./hosts/darwin/${hostname}.nix
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
  in {
    schemas = flake-schemas.schemas;

    darwinConfigurations = {
      "Adams-Macbook-Pro" = mkDarwinSystem "Adams-Macbook-Pro" "aarch64-darwin";
      "Adams-Work-Macbook-Pro" = mkDarwinSystem "Adams-Work-Macbook-Pro" "aarch64-darwin";
    };

    formatter = forEachSupportedSystem ({pkgs, ...}: pkgs.alejandra);
  };
}
