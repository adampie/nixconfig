# Devenv package
{...}: {
  flake.modules.homeManager.devenv = {pkgs, ...}: {
    home.packages = with pkgs; [
      devenv
    ];
  };
}
