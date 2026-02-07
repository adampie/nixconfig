{config, ...}: let
  dm = config.flake.modules.darwin;
  hm = config.flake.modules.homeManager;
in {
  flake.modules.darwin.system-desktop = {
    imports = [
      dm.system-cli
    ];
  };

  flake.modules.homeManager.system-desktop = {
    imports = [
      hm.system-cli
      hm.zed
      hm.ghostty
      hm.jetbrains
    ];
  };
}
