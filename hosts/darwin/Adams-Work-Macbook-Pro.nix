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
    hostname = "Adams-Work-Macbook-Pro";
    homeProfile = ../../profiles/work/home.nix;
  };

  system.defaults = {};
}
