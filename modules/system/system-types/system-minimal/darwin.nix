{...}: {
  flake.modules.darwin.system-minimal = {
    nix.enable = false;

    nixpkgs.config.allowUnfree = true;

    system.stateVersion = 6;
  };
}
