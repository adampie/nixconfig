{ self, inputs, ... }:
{
  flake.darwinConfigurations.Adams-MacBook-Pro = inputs.nix-darwin.lib.darwinSystem {
    modules = [ self.darwinModules.hostMacBook ];
  };

  flake.darwinModules.hostMacBook =
    { ... }:
    let
      username = "adampie";
      homeDirectory = "/Users/${username}";
    in
    {
      imports = [
        inputs.home-manager.darwinModules.home-manager
        self.darwinModules.homebrew
        self.darwinModules.homebrewBrews
        self.darwinModules.homebrewCasks
        self.darwinModules.homebrewMas
        self.darwinModules.homebrewTaps
      ];

      nixpkgs.hostPlatform = "aarch64-darwin";
      system.primaryUser = username;
      system.stateVersion = 6;
      networking.hostName = "Adams-MacBook-Pro";

      users.users.${username} = {
        name = username;
        home = homeDirectory;
      };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${username} = {
          imports = [
            self.homeModules.brewEnv
            self.homeModules.claudeCode
            self.homeModules.fonts
            self.homeModules.ghostty
            self.homeModules.git
            self.homeModules.gpg
            self.homeModules.mise
            self.homeModules.ssh
            self.homeModules.starship
            self.homeModules.zed
            self.homeModules.zsh
          ];
          home = {
            inherit username homeDirectory;
            stateVersion = "25.11";
          };
        };
      };
    };
}
