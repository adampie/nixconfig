{
  description = "Nix config by adampie";

  inputs = {
    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/*";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    nixpkgs-unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    # Add other inputs as needed
  };

  outputs = { self, flake-schemas, nixpkgs, nixpkgs-unstable, ... }@inputs: let
    supportedSystems = ["x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
  in {
    schemas = flake-schemas.schemas;

    # --- System configurations (Darwin/macOS) ---
    darwinConfigurations = {
      "Adams-Macbook-Pro" = {};
      "Adams-Work-Macbook-Pro" = {};
    };

    # --- Home Manager configurations ---
    homeConfigurations = {
      # Example stub:
      # "adampie@Adams-Macbook-Pro" = {};
    };

    # --- Profiles (personal, work) ---
    profiles = {
      personal = {};
      work = {};
    };
  };
}
