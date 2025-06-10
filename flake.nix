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
    lib = import ./lib/default.nix { inherit (nixpkgs) lib; };

    forEachSupportedSystem = lib.forEachSupportedSystem {
      inherit supportedSystems nixpkgs nixpkgs-unstable;
    };

    mkDarwinSystem = hostname: system:
      lib.mkDarwinSystem {
        inherit hostname system inputs home-manager;
        unstablepkgs = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
  in {
    schemas = flake-schemas.schemas;

    darwinConfigurations = {
      "Adams-MacBook-Pro" = mkDarwinSystem "Adams-MacBook-Pro" "aarch64-darwin";
      "Adams-Work-MacBook-Pro" = mkDarwinSystem "Adams-Work-MacBook-Pro" "aarch64-darwin";
    };

    formatter = forEachSupportedSystem ({pkgs, ...}: pkgs.alejandra);
  };
}
