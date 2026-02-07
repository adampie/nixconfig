{inputs, ...}: {
  flake.lib = {
    mkDarwin = system: hostname: modules:
      inputs.nix-darwin.lib.darwinSystem {
        inherit system;
        modules =
          [{networking.hostName = hostname;}]
          ++ modules
          ++ [
            inputs.home-manager.darwinModules.home-manager
          ];
      };

    mkNixos = system: hostname: modules:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules =
          [{networking.hostName = hostname;}]
          ++ modules
          ++ [
            inputs.home-manager.nixosModules.home-manager
          ];
      };
  };
}
