{
  lib,
  mkJetBrainsDarwinScript,
  ...
}: let
  mkHomeManagerModule = extraSpecialArgs: {
    nixpkgs.config.allowUnfree = true;
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      inherit extraSpecialArgs;
    };
  };
in {
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
        (mkHomeManagerModule {
          inherit unstablepkgs mkJetBrainsDarwinScript;
        })
      ];
    };

  mkNixOSSystem = {
    hostname,
    system,
    hardware ? null,
    inputs,
    unstablepkgs,
    home-manager,
  }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs unstablepkgs;
      };
      modules =
        [
          ../hosts/nixos/${hostname}.nix
          home-manager.nixosModules.home-manager
          (mkHomeManagerModule {inherit unstablepkgs;})
        ]
        ++ lib.optionals (hardware != null) [
          ../modules/hardware/${hardware}.nix
        ];
    };

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
