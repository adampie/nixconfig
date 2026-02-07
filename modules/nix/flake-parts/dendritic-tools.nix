{lib, ...}: {
  options.flake.modules = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf lib.types.raw);
    default = {};
    description = "Module sets for darwin, nixos, and homeManager configurations";
  };

  config = {
    flake.modules = {
      darwin = {};
      nixos = {};
      homeManager = {};
    };

    systems = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
