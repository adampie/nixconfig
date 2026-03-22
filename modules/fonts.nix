{ ... }:
{
  flake.homeModules.fonts =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.nerd-fonts.hack
      ];
    };
}
