{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/system/darwin.nix
    ../../profiles/shared/homebrew.nix
    ../../profiles/personal/homebrew.nix
  ];

  host = {
    username = "adampie";
    hostname = "Adams-Macbook-Pro";
    homeProfile = ../../profiles/personal/default.nix;
  };

  system.defaults = {};
}
