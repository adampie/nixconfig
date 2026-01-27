# Dendritic pattern: Define flake.modules options for aspect-oriented configuration
{lib, config, ...}: {
  options.flake.modules = lib.mkOption {
    type = lib.types.submodule {
      freeformType = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
      options = {};
    };
    default = {};
    description = ''
      Dendritic modules organized by configuration class (darwin, nixos, homeManager) 
      and aspect/feature name. Each module can be imported into the corresponding system type.
    '';
  };
}
