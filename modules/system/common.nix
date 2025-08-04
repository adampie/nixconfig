{
  config,
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

      platform = lib.mkOption {
        type = lib.types.enum ["darwin" "nixos"];
        description = "The platform type for this system";
      };

      systemType = lib.mkOption {
        type = lib.types.enum ["personal" "work" "server"];
        description = "The type/role of this system";
      };

      architecture = lib.mkOption {
        type = lib.types.enum ["aarch64" "x86_64"];
        description = "The CPU architecture";
      };
    };

    # Platform detection helpers
    isDarwin = lib.mkOption {
      type = lib.types.bool;
      default = config.host.platform == "darwin";
      readOnly = true;
      description = "Whether this is a Darwin (macOS) system";
    };

    isNixOS = lib.mkOption {
      type = lib.types.bool;
      default = config.host.platform == "nixos";
      readOnly = true;
      description = "Whether this is a NixOS system";
    };

    isPersonal = lib.mkOption {
      type = lib.types.bool;
      default = config.host.systemType == "personal";
      readOnly = true;
      description = "Whether this is a personal system";
    };

    isWork = lib.mkOption {
      type = lib.types.bool;
      default = config.host.systemType == "work";
      readOnly = true;
      description = "Whether this is a work system";
    };

    isServer = lib.mkOption {
      type = lib.types.bool;
      default = config.host.systemType == "server";
      readOnly = true;
      description = "Whether this is a server system";
    };

    isAarch64 = lib.mkOption {
      type = lib.types.bool;
      default = config.host.architecture == "aarch64";
      readOnly = true;
      description = "Whether this is an ARM64 system";
    };

    isX86_64 = lib.mkOption {
      type = lib.types.bool;
      default = config.host.architecture == "x86_64";
      readOnly = true;
      description = "Whether this is an x86_64 system";
    };
  };
}
