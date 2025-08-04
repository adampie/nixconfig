_: {
  imports = [
    ../../modules/system/darwin.nix
    ../../profiles/shared/homebrew.nix
    ../../profiles/work/homebrew.nix
  ];

  host = {
    username = "adampie";
    hostname = "Adams-Work-MacBook-Pro";
    homeProfile = ../../profiles/work/default.nix;
    platform = "darwin";
    systemType = "work";
    architecture = "aarch64";
  };

  system.defaults = {};
}
