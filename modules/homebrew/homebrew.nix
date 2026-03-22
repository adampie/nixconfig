{ ... }: {
  flake.darwinModules.homebrew = { ... }: {
    homebrew = {
      enable = true;
      onActivation = {
        cleanup = "zap";
        autoUpdate = true;
        upgrade = true;
      };
    };
  };
}
