{...}: {
  flake.modules.darwin.host-options = {
    config,
    lib,
    ...
  }: {
    options = {
      host = {
        username = lib.mkOption {
          type = lib.types.str;
          description = "Primary username for this host";
        };

        hostname = lib.mkOption {
          type = lib.types.str;
          description = "System hostname";
        };

        platform = lib.mkOption {
          type = lib.types.enum ["darwin" "nixos"];
          description = "Platform type for this system";
        };

        systemType = lib.mkOption {
          type = lib.types.enum ["personal" "work" "server"];
          description = "Role classification for this system";
        };

        architecture = lib.mkOption {
          type = lib.types.enum ["aarch64" "x86_64"];
          description = "CPU architecture";
        };
      };

      isDarwin = lib.mkOption {
        type = lib.types.bool;
        default = config.host.platform == "darwin";
        readOnly = true;
      };

      isNixOS = lib.mkOption {
        type = lib.types.bool;
        default = config.host.platform == "nixos";
        readOnly = true;
      };

      isPersonal = lib.mkOption {
        type = lib.types.bool;
        default = config.host.systemType == "personal";
        readOnly = true;
      };

      isWork = lib.mkOption {
        type = lib.types.bool;
        default = config.host.systemType == "work";
        readOnly = true;
      };

      isServer = lib.mkOption {
        type = lib.types.bool;
        default = config.host.systemType == "server";
        readOnly = true;
      };

      isAarch64 = lib.mkOption {
        type = lib.types.bool;
        default = config.host.architecture == "aarch64";
        readOnly = true;
      };

      isX86_64 = lib.mkOption {
        type = lib.types.bool;
        default = config.host.architecture == "x86_64";
        readOnly = true;
      };
    };
  };
}
