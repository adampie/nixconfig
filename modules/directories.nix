{ ... }: {
  flake.homeModules.directories = { lib, ... }: {
    home.activation.createDirectories = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD mkdir -p $HOME/Code
      $DRY_RUN_CMD mkdir -p $HOME/Screenshots
    '';
  };
}
