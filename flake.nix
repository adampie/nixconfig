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
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    flake-schemas,
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
        inherit (config) system;
        config.allowUnfree = true;
      };
    in
      if config.type == "darwin"
      then
        lib.mkDarwinSystem {
          inherit hostname inputs home-manager unstablepkgs;
          inherit (config) system;
        }
      else if config.type == "nixos"
      then
        lib.mkNixOSSystem {
          inherit hostname inputs home-manager unstablepkgs;
          inherit (config) system profile;
          hardware = config.hardware or null;
        }
      else throw "Unknown system type: ${config.type}";

    darwinSystems = nixpkgs.lib.filterAttrs (_: v: v.type == "darwin") systems;
    nixosSystems = nixpkgs.lib.filterAttrs (_: v: v.type == "nixos") systems;
  in {
    inherit (flake-schemas) schemas;

    darwinConfigurations = nixpkgs.lib.mapAttrs mkSystem darwinSystems;
    nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem nixosSystems;

    formatter = forEachSupportedSystem ({pkgs, ...}: pkgs.alejandra);

    devShells = forEachSupportedSystem ({pkgs, ...}: {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # Nix tooling
          alejandra
          deadnix
          nil
          nixd
          statix

          # Development utilities
          git
          gh
        ];

        shellHook = ''
          echo "🛠️  Nix development environment"
          echo ""
          echo "Available tools:"
          echo "  alejandra - Nix code formatter"
          echo "  statix    - Nix code linter"
          echo "  deadnix   - Find unused Nix code"
          echo "  nil/nixd  - Nix language servers"
          echo ""
          echo "Run 'nix fmt' to format code"
          echo "Run 'nix flake check' to validate"
        '';
      };
    });

    checks = forEachSupportedSystem ({pkgs, ...}: {
      statix = pkgs.runCommand "statix-check" {} ''
        ${pkgs.statix}/bin/statix check ${./.} --ignore=flake.lock
        touch $out
      '';

      deadnix = pkgs.runCommand "deadnix-check" {} ''
        ${pkgs.deadnix}/bin/deadnix --fail ${./.}
        touch $out
      '';

      format = pkgs.runCommand "format-check" {} ''
        ${pkgs.alejandra}/bin/alejandra --check ${./.}
        touch $out
      '';
    });
  };
}
