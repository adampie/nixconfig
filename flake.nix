{
  description = "Nix config by adampie";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";
  };

  outputs = inputs: let
    lib = inputs.nixpkgs.lib;
    modules = lib.pipe inputs.import-tree [
      (i: i.addPath ./modules)
      (i:
        i.filterNot (path: let
          s = toString path;
        in
          builtins.match ".*(hosts|users)/(.*/)?(configuration|homeManager)\\.nix" s != null))
      (i: i.result)
    ];
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} modules;
}
