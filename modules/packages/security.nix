{ ... }:
{
  flake.homeModules.packagesSecurity =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        osv-scanner
        zizmor
      ];
    };
}
