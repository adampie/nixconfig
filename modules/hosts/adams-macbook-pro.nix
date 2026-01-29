{
  inputs,
  config,
  lib,
  ...
}: let
  system = "aarch64-darwin";
  darwinModules = lib.concatLists (builtins.attrValues config.flake.modules.darwin);
  hmModules = lib.concatLists (builtins.attrValues config.flake.modules.homeManager);
in {
  flake.darwinConfigurations."Adams-MacBook-Pro" = inputs.nix-darwin.lib.darwinSystem {
    inherit system;
    modules =
      darwinModules
      ++ [
        {
          host = {
            username = "adampie";
            hostname = "Adams-MacBook-Pro";
            platform = "darwin";
            systemType = "personal";
            architecture = "aarch64";
          };
        }
        inputs.home-manager.darwinModules.home-manager
        {
          nixpkgs.config.allowUnfree = true;
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.adampie.imports = hmModules;
          };
        }
      ];
  };
}
