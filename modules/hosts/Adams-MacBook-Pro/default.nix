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
        self.darwinModules.defaults
        self.darwinModules.homebrew
        self.darwinModules.homebrewBrews
        self.darwinModules.homebrewCasks
        self.darwinModules.homebrewMas
        self.darwinModules.homebrewTaps
      ];

      documentation.enable = false;
      nix.enable = false;
      nixpkgs.hostPlatform = "aarch64-darwin";
      system.primaryUser = username;
      system.stateVersion = 6;
      networking.hostName = "Adams-MacBook-Pro";

      users.users.${username} = {
        name = username;
        home = homeDirectory;
      };

      home-manager = {
        backupFileExtension = "backup";
        overwriteBackup = true;
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${username} = {
          imports = [
            self.homeModules.brewEnv
            self.homeModules.claudeCode
            self.homeModules.directories
            self.homeModules.fonts
            self.homeModules.ghostty
            self.homeModules.git
            self.homeModules.gpg
            self.homeModules.direnv
            self.homeModules.jetbrains
            self.homeModules.mise
            self.homeModules.nixIndex
            self.homeModules.optOut
            self.homeModules.ssh
            self.homeModules.starship
            self.homeModules.zed
            self.homeModules.shell
            self.homeModules.packagesCommon
            self.homeModules.packagesDevelopment
            self.homeModules.packagesSecurity
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
