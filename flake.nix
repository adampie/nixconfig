{
  description = "Nix config by adampie";

  inputs = {
    # nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    # nixpkgs-unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";

    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/0";

    nix-darwin = {
      # url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      # url = "github:nix-community/home-manager/release-25.11";
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    ...
  } @ inputs: let
    supportedSystems = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    lib = import ./lib/default.nix {inherit (nixpkgs) lib;};

    forEachSupportedSystem = lib.forEachSupportedSystem {
      inherit supportedSystems nixpkgs nixpkgs-stable;
    };

    hostFiles = let
      darwinDir = ./hosts/darwin;
      entries = builtins.readDir darwinDir;
      hostNames = builtins.filter (name: entries.${name} == "directory") (builtins.attrNames entries);
    in
      builtins.listToAttrs (
        map (name: {
          inherit name;
          value = {
            system = "aarch64-darwin";
            type = "darwin";
            modules = [
              (darwinDir + "/${name}/default.nix")
            ];
          };
        })
        hostNames
      );

    mkSystem = _: config: let
      stablepkgs = import nixpkgs-stable {
        inherit (config) system;
        config.allowUnfree = true;
      };
    in
      if config.type == "darwin"
      then
        lib.mkDarwinSystem {
          inherit inputs home-manager stablepkgs;
          inherit (config) system modules;
        }
      else if config.type == "nixos"
      then
        lib.mkNixOSSystem {
          inherit inputs home-manager stablepkgs;
          inherit (config) system modules;
          hardware = config.hardware or null;
        }
      else throw "Unknown system type: ${config.type}";

    darwinSystems = nixpkgs.lib.filterAttrs (_: v: v.type == "darwin") hostFiles;
    nixosSystems = nixpkgs.lib.filterAttrs (_: v: v.type == "nixos") hostFiles;
  in {
    darwinConfigurations = nixpkgs.lib.mapAttrs mkSystem darwinSystems;
    nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem nixosSystems;

    formatter = forEachSupportedSystem ({pkgs, ...}:
      pkgs.writeShellApplication {
        name = "fmt";
        runtimeInputs = [pkgs.alejandra];
        text = ''
          if [ "$#" -eq 0 ]; then
            exec alejandra .
          fi
          exec alejandra "$@"
        '';
      });

    devShells = forEachSupportedSystem (
      {pkgs, ...}: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            alejandra
            deadnix
            mise
            nil
            nixd
            statix
          ];

          shellHook = ''
            echo "Run 'nix fmt' to format code"
            echo "Run 'nix flake check' to validate"
          '';
        };
      }
    );

    checks = forEachSupportedSystem (
      {pkgs, ...}: {
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
      }
    );
  };
}
