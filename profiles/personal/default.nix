{
  config,
  pkgs,
  unstablepkgs,
  lib,
  ...
}: {
  imports = [
    ../shared/home.nix
    ../shared/packages.nix
    ../shared/programs.nix
    ./home.nix
    ./packages.nix
    ./programs.nix
  ];
}
