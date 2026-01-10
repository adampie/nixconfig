{lib, ...}: let
  mkJetBrainsDarwinScript = appName: appBinary: {
    text = ''
      #!/bin/zsh
      "/Applications/${appBinary}/Contents/MacOS/${appName}" "$@" > /dev/null 2>&1 &
    '';
    executable = true;
  };

  mkHomeManagerModule = extraSpecialArgs: {
    nixpkgs.config.allowUnfree = true;
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      inherit extraSpecialArgs;
    };
  };
in {
  inherit mkJetBrainsDarwinScript;

  mkDarwinSystem = {
    system,
    modules,
    inputs,
    stablepkgs,
    home-manager,
  }:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit inputs stablepkgs mkJetBrainsDarwinScript;
      };
      modules =
        modules
        ++ [
          home-manager.darwinModules.home-manager
          (mkHomeManagerModule {
            inherit inputs stablepkgs mkJetBrainsDarwinScript;
          })
        ];
    };

  mkNixOSSystem = {
    system,
    modules,
    hardware ? null,
    inputs,
    stablepkgs,
    home-manager,
  }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs stablepkgs;
      };
      modules =
        modules
        ++ [
          home-manager.nixosModules.home-manager
          (mkHomeManagerModule {inherit inputs stablepkgs;})
        ]
        ++ lib.optionals (hardware != null) [
          ../modules/hardware/${hardware}.nix
        ];
    };

  forEachSupportedSystem = {
    supportedSystems,
    nixpkgs,
    nixpkgs-stable,
  }: f:
    lib.genAttrs supportedSystems (system:
      f {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        stablepkgs = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      });
}
