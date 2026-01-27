# Nix daemon configuration
{...}: {
  flake.modules.darwin.nix-daemon = {
    nix.enable = false;
  };
}
