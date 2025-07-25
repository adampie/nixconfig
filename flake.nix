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
    supportedSystems = ["aarch64-darwin" "aarch64-linux" "x86_64-linux"];
    lib = import ./lib/default.nix {inherit (nixpkgs) lib;};

    forEachSupportedSystem = lib.forEachSupportedSystem {
      inherit supportedSystems nixpkgs nixpkgs-unstable;
    };

    systems = {
      "Adams-MacBook-Pro" = {
        system = "aarch64-darwin";
        type = "darwin";
        profile = "personal";
      };
      "Adams-Work-MacBook-Pro" = {
        system = "aarch64-darwin";
        type = "darwin";
        profile = "work";
      };
    };

    mkSystem = hostname: config: let
      unstablepkgs = import nixpkgs-unstable {
        system = config.system;
        config.allowUnfree = true;
      };
    in
      if config.type == "darwin"
      then
        lib.mkDarwinSystem {
          inherit hostname inputs home-manager unstablepkgs;
          system = config.system;
        }
      else if config.type == "nixos"
      then
        lib.mkNixOSSystem {
          inherit hostname inputs home-manager unstablepkgs;
          system = config.system;
          profile = config.profile;
          hardware = config.hardware or null;
        }
      else throw "Unknown system type: ${config.type}";

    darwinSystems = nixpkgs.lib.filterAttrs (n: v: v.type == "darwin") systems;
    nixosSystems = nixpkgs.lib.filterAttrs (n: v: v.type == "nixos") systems;
  in {
    schemas = flake-schemas.schemas;

    darwinConfigurations = nixpkgs.lib.mapAttrs mkSystem darwinSystems;
    nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem nixosSystems;

    formatter = forEachSupportedSystem ({pkgs, ...}: pkgs.alejandra);
  };
}
