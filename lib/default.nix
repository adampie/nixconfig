{lib, ...}: let
  mkJetBrainsDarwinScript = appName: appBinary: {
    text = ''
      #!/bin/zsh
      "/Applications/${appBinary}/Contents/MacOS/${appName}" "$@" > /dev/null 2>&1 &
    '';
    executable = true;
  };

  # CallPackage pattern for better composability
  callPackageWith = autoArgs: fn: args: let
    f =
      if lib.isFunction fn
      then fn
      else import fn;
    fargs = lib.functionArgs f;
  in
    f ((lib.intersectAttrs fargs autoArgs) // args);

  # Make a package set with callPackage
  makePackageSet = pkgs: {
    callPackage = callPackageWith pkgs;
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
        ]
        ++ lib.optionals (hardware != null) [
          ../modules/hardware/${hardware}.nix
        ];
    };

  inherit mkJetBrainsDarwinScript callPackageWith makePackageSet;

  # Platform helpers
  mkConditionalPackages = {
    pkgs,
    darwin ? [],
    linux ? [],
    common ? [],
  }:
    common
    ++ lib.optionals pkgs.stdenv.isDarwin darwin
    ++ lib.optionals pkgs.stdenv.isLinux linux;
}
