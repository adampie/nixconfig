{ ... }:
{
  flake.homeModules.fonts =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.nerd-fonts.hack
      ];
    };

  flake.nixosModules.fonts =
    { pkgs, ... }:
    {
      fonts = {
        fontDir.enable = true;
        packages = with pkgs; [
          nerd-fonts.hack
        ];
        fontconfig.defaultFonts.monospace = [ "Hack Nerd Font" ];
      };
    };
}
