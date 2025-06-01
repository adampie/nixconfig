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
    supportedSystems = ["x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux"];

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

    commonArgs = system: {
      specialArgs = {
        inherit inputs;
        unstablepkgs = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    };
  in {
    schemas = flake-schemas.schemas;

    darwinConfigurations = {
      "Adams-Macbook-Pro" = nix-darwin.lib.darwinSystem ({
          system = "aarch64-darwin";
          modules = [
            ./hosts/darwin/Adams-Macbook-Pro.nix
            home-manager.darwinModules.home-manager
            {
              nixpkgs.config.allowUnfree = true;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  unstablepkgs = import nixpkgs-unstable {
                    system = "aarch64-darwin";
                    config.allowUnfree = true;
                  };
                };
              };
            }
          ];
        }
        // (commonArgs "aarch64-darwin"));

      "Adams-Work-Macbook-Pro" = nix-darwin.lib.darwinSystem ({
          system = "aarch64-darwin";
          modules = [
            ./hosts/darwin/Adams-Work-Macbook-Pro.nix
            home-manager.darwinModules.home-manager
            {
              nixpkgs.config.allowUnfree = true;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  unstablepkgs = import nixpkgs-unstable {
                    system = "aarch64-darwin";
                    config.allowUnfree = true;
                  };
                };
              };
            }
          ];
        }
        // (commonArgs "aarch64-darwin"));
    };
  };
}
