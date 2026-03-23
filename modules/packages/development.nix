{ ... }:
{
  flake.homeModules.packagesDevelopment =
    { pkgs, lib, ... }:
    {
      home.packages =
        with pkgs;
        [
          fh
          gh
          nil
          nixd
        ]
        ++ lib.optionals (!pkgs.stdenv.isDarwin) [
          jetbrains.datagrip
          jetbrains.goland
          jetbrains.idea-ultimate
          jetbrains.pycharm-professional
          jetbrains.webstorm
          jetbrains.rust-rover
        ];
    };
}
