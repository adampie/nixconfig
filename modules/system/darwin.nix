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
    nix.enable = false;
    system.stateVersion = 6;

    users.users.${username} = {
      name = username;
      home = "/Users/${username}";
    };

    system.primaryUser = username;

    home-manager.users.${username} = import config.host.homeProfile;

    networking.hostName = config.host.hostname;

    security.pam.services.sudo_local.touchIdAuth = true;

    system.defaults = lib.mkDefault {};
  };
}
