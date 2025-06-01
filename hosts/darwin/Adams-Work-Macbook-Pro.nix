{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/system/darwin.nix
    ../../profiles/work/default.nix
  ];

  host = {
    username = "adampie";
    hostname = "Adams-Work-Macbook-Pro";
    profile = ../../profiles/work/default.nix;
  };

  system.defaults = {};
}
