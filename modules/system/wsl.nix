{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    host = {
      username = lib.mkOption {
        type = lib.types.str;
        description = "The primary username for this host";
      };

      hostname = lib.mkOption {
        type = lib.types.str;
        description = "The hostname for this system";
      };

      homeProfile = lib.mkOption {
        type = lib.types.path;
        description = "Path to the home-manager profile to use";
      };
    };
  };

  config = let
    username = config.host.username;
  in {
    system.stateVersion = "25.05";

    # WSL specific configuration
    wsl = {
      enable = true;
      defaultUser = username;
    };

    users.users.${username} = {
      isNormalUser = true;
      home = "/home/${username}";
      extraGroups = ["wheel"];
    };

    home-manager.backupFileExtension = "backup";
    home-manager.users.${username} = import config.host.homeProfile;
    networking.hostName = config.host.hostname;

    # Enable Nix flakes
    nix.settings.experimental-features = ["nix-command" "flakes"];

    # Enable sudo for wheel group
    security.sudo.wheelNeedsPassword = false;
  };
}
