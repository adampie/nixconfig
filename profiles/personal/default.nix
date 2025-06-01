{
  config,
  pkgs,
  unstablepkgs,
  lib,
  ...
}: {
  imports = [
    ../shared/homebrew.nix
  ];

  homebrew.casks = [
    "daisydisk"
    "little-snitch"
    "lm-studio"
    "micro-snitch"
  ];

  homebrew.masApps = {
    "Flighty" = 1358823008;
  };
}
