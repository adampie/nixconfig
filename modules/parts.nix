{ lib, ... }:
{
  options.flake = {
    darwinModules = lib.mkOption {
      type = lib.types.attrsOf lib.types.raw;
      default = { };
    };
    homeModules = lib.mkOption {
      type = lib.types.attrsOf lib.types.raw;
      default = { };
    };
    nixosModules = lib.mkOption {
      type = lib.types.attrsOf lib.types.raw;
      default = { };
    };
  };

  config.systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];
}
