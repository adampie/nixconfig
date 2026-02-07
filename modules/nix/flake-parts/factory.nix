{lib, ...}: {
  options.flake.factory = lib.mkOption {
    type = lib.types.attrsOf lib.types.raw;
    default = {};
    description = "Factory functions for creating user/system configurations";
  };
}
