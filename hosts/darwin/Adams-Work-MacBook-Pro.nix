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
    hostname = "Adams-Work-MacBook-Pro";
    homeProfile = ../../profiles/work/default.nix;
  };

  system.defaults = {};
}
