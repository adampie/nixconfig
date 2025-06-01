{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/system/darwin.nix
  ];

  host = {
    username = "adampie";
    hostname = "Adams-Macbook-Pro";
    homeProfile = ../../profiles/personal/home.nix;
  };

  system.defaults = {};
}
