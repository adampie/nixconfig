{lib}: let
  # Creates a script to launch JetBrains IDEs on macOS (Darwin) only
  mkJetBrainsDarwinScript = appName: appBinary: {
    text = ''
      #!/bin/zsh
      "/Applications/${appBinary}/Contents/MacOS/${appName}" "$@" > /dev/null 2>&1 &
    '';
    executable = true;
  };
in {
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
              inherit unstablepkgs mkJetBrainsDarwinScript;
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

  # Export the helper function for direct use
  inherit mkJetBrainsDarwinScript;
}
