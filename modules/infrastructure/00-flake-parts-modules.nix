# Import flake-parts modules support for dendritic pattern
# This enables the flake.modules.* pattern to work properly
{inputs, lib, config, ...}: 
let
  modulesFlakeModule = inputs.flake-parts.flakeModules.modules;
in
{
  imports = [
    modulesFlakeModule
  ];
  
  # Verify this module loads
  options._test = lib.mkOption {
    type = lib.types.bool;
    default = true;
  };
}
