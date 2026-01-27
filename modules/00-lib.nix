# Expose lib functions as a flake-parts module
# The underscore prefix ensures this loads first
{inputs, ...}: {
  flake.lib = import ../lib/default.nix {inherit (inputs.nixpkgs) lib;};
}
