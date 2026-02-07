{config, ...}: let
  dm = config.flake.modules.darwin;
  hm = config.flake.modules.homeManager;
in {
  flake.modules.darwin.system-default = {
    imports = [
      dm.system-minimal
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      overwriteBackup = true;
      backupFileExtension = "backup";
    };
  };

  flake.modules.homeManager.system-default = {
    imports = [
      hm.system-minimal
    ];
  };
}
