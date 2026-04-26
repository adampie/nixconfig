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
        self.nixosModules.defaults
        self.nixosModules.fail2ban
        self.nixosModules.fonts
        self.nixosModules.gnome
#        self.nixosModules.llamaCpp
        self.nixosModules.llmAgents
        self.nixosModules.mullvad
        self.nixosModules.openssh
        self.nixosModules.podman
        self.nixosModules.towerDisko
        self.nixosModules.towerHardware
      ];

      system.stateVersion = "25.11";

      # Network
      networking.hostName = "tower";
      networking.networkmanager.enable = true;

      services.openssh.settings.AllowUsers = [ "adampie" ];

      # User
      users.users.${username} = {
        isNormalUser = true;
        home = homeDirectory;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIYZ1p3R75b204KSQl4887UafxsK+ybuEbSZPd58ZaJ1"
        ];
      };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${username} = {
          imports = [
            self.homeModules.claudeCode
            self.homeModules.codex
            self.homeModules.directories
            self.homeModules.direnv
            self.homeModules.fonts
            self.homeModules.ghostty
            self.homeModules.git
            self.homeModules.gpg
            self.homeModules.jetbrains
            self.homeModules.mise
            self.homeModules.nixIndex
            self.homeModules.optOut
            self.homeModules.packagesApps
            self.homeModules.packagesCommon
            self.homeModules.packagesDevelopment
            self.homeModules.packagesSecurity
            self.homeModules.shell
            self.homeModules.starship
            self.homeModules.terraform
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
