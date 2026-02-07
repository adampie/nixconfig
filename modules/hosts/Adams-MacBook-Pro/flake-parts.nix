{
  self,
  config,
  ...
}: let
  dm = config.flake.modules.darwin;
  hm = config.flake.modules.homeManager;
in {
  flake.darwinConfigurations.Adams-MacBook-Pro = self.lib.mkDarwin "aarch64-darwin" "Adams-MacBook-Pro" [
    dm.system-desktop
    ./configuration.nix
    ../../users/adampie/configuration.nix
    {
      home-manager.users.adampie = {
        imports = [
          hm.system-desktop
          hm.fetch-all-code
          ../../users/adampie/homeManager.nix
        ];
      };
    }
  ];
}
