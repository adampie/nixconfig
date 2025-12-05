_: {
  imports = [
    ../../modules/system/darwin.nix
    ../../profiles/shared/homebrew.nix
    ../../profiles/personal/homebrew.nix
  ];

  host = {
    username = "adampie";
    hostname = "Adams-MacBook-Pro";
    homeProfile = ../../profiles/personal/default.nix;
    platform = "darwin";
    systemType = "personal";
    architecture = "aarch64";
  };

  networking.applicationFirewall = {
    enable = true;
    allowSigned = true;
    allowSignedApp = true;
    enableStealthMode = true;
  };
}
