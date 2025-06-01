{
  config,
  pkgs,
  unstablepkgs,
  lib,
  ...
}: {
  imports = [
    ../shared/packages.nix
    ../shared/homebrew.nix
    ../../modules/home/platforms/darwin.nix
  ];

  home.packages = with pkgs; [];

  homebrew.casks = [];

  programs = {};

  home.sessionVariables = {};
}
