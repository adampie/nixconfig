{
  description = "Nix config by adampie";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    opt-out.url = "https://flakehub.com/f/adampie/opt-out/0.1";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ai = {
      url = "github:adampie/ai";
      flake = false;
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      {
        imports = [ (inputs.import-tree ./modules) ];

        options.flake = {
          darwinModules = lib.mkOption {
            type = lib.types.attrsOf lib.types.raw;
            default = { };
          };
          homeModules = lib.mkOption {
            type = lib.types.attrsOf lib.types.raw;
            default = { };
          };
        };

        config.systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
        ];

        config.perSystem =
          { pkgs, ... }:
          {
            formatter = pkgs.nixfmt-tree;
          };
      }
    );
}
