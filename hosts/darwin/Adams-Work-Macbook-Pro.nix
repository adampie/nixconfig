{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/system/darwin.nix
    ../../profiles/shared/homebrew.nix
    ../../profiles/work/homebrew.nix
  ];

  host = {
    username = "adampie";
    hostname = "Adams-Work-Macbook-Pro";
    homeProfile = ../../profiles/work/home.nix;
  };

  system.defaults = {};
}
