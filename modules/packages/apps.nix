{ ... }:
{
  flake.homeModules.packagesApps =
    { pkgs, lib, ... }:
    {
      home.packages = lib.optionals pkgs.stdenv.isLinux (
        with pkgs; [
          discord
          slack
          spotify
          vlc
        ]
      );
    };
}
