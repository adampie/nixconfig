{ ... }:
{
  flake.homeModules.packagesDevelopment =
    { pkgs, lib, ... }:
    {
      home.packages =
        with pkgs;
        [
          devenv
          direnv
          fh
          gh
          nil
          nixd
        ]
        ++ lib.optionals (!pkgs.stdenv.isDarwin) [
          jetbrains.datagrip
          jetbrains.goland
          jetbrains.idea
          jetbrains.pycharm
          jetbrains.webstorm
          jetbrains.rust-rover
        ];
    };
}
