{ self, inputs, ... }:
{
  flake.nixosConfigurations.tower = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.hostTower ];
  };

  flake.nixosModules.hostTower =
    { ... }:
    let
      username = "adampie";
      homeDirectory = "/home/${username}";
    in
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      nixpkgs.hostPlatform = "x86_64-linux";
      system.stateVersion = "25.11";

      networking.hostName = "tower";

      users.users.${username} = {
        isNormalUser = true;
        home = homeDirectory;
        extraGroups = [ "wheel" ];
      };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${username} = {
          imports = [
            self.homeModules.git
          ];
          home = {
            inherit username homeDirectory;
            stateVersion = "25.11";
          };
        };
      };
    };
}
