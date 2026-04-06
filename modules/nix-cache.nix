{ ... }:
{
  flake.homeModules.nixCache =
    { pkgs, ... }:
    {
      nix.package = pkgs.nix;
      nix.settings = {
        substituters = [
          "https://cache.adampie.dev"
          "https://cache.nixos.org"
        ];
        trusted-public-keys = [
          "cache.adampie.dev-1:njftfmru8p5NnYbVcfE22Tq0Ku+pEEplGs0nVqIGCUE="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        ];
      };
    };
}
