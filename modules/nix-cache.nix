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
          "cache.adampie.dev-1:bYRS3Q1Jq7IaqK5wfN6Tw4Qeo51d1kV3YaPvpfEx+ek="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        ];
      };
    };
}
