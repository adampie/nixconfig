{ ... }:
{
  flake.homeModules.packagesSecurity =
    { pkgs, lib, ... }:
    {
      home.packages =
        with pkgs;
        [
          osv-scanner
        ]
        ++ lib.optionals (!pkgs.stdenv.isDarwin) [
        ];
    };
}
