{
  description = "Nix config by adampie";

  inputs = {
    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/*";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    nixpkgs-unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    nix-darwin.url = "github:lnl7/nix-darwin"; nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, flake-schemas, nixpkgs, nixpkgs-unstable, nix-darwin, ... }@inputs: let
    supportedSystems = ["x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
  in {
    schemas = flake-schemas.schemas;

    # --- System configurations (Darwin/macOS) ---
    darwinConfigurations = {
      "Adams-Macbook-Pro" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/darwin/Adams-Macbook-Pro.nix
        ];
      };
      "Adams-Work-Macbook-Pro" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/darwin/Adams-Work-Macbook-Pro.nix
        ];
      };
    };

    # --- Home Manager configurations ---
    homeConfigurations = {
      "adampie@Adams-Macbook-Pro" = {};
      "adampie@Adams-Work-Macbook-Pro" = {};
    };

    # --- Profiles (personal, work) ---
    profiles = {
      personal = {};
      work = {};
    };
  };
}
