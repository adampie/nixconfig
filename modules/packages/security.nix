{ ... }:
{
  flake.homeModules.packagesSecurity =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        betterleaks
        osv-scanner
        zizmor
      ];
    };
}
