{lib, ...}: {
  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-linux"
  ];

  options.flake = lib.mkOption {
    type = lib.types.submoduleWith {
      modules = [
        {
          options.modules = {
            darwin = lib.mkOption {
              type = lib.types.attrsOf lib.types.deferredModule;
              default = {};
              description = "Darwin modules organized by aspect";
            };
            homeManager = lib.mkOption {
              type = lib.types.attrsOf lib.types.deferredModule;
              default = {};
              description = "Home Manager modules organized by aspect";
            };
          };
        }
      ];
    };
  };
}
