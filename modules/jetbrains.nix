{ ... }:
{
  flake.homeModules.jetbrains =
    { pkgs, lib, ... }:
    let
      mkMacLauncher = name: app: {
        text = ''
          #!/bin/zsh
          "/Applications/${app}/Contents/MacOS/${name}" "$@" > /dev/null 2>&1 &
        '';
        executable = true;
      };
      mkLinuxLauncher = pkg: {
        text = ''
          #!${pkgs.zsh}/bin/zsh
          ${lib.getExe pkg} "$@" > /dev/null 2>&1 &!
        '';
        executable = true;
      };
    in
    {
      home.file = lib.mkMerge [
        (lib.mkIf pkgs.stdenv.isDarwin {
          ".local/bin/datagrip" = mkMacLauncher "datagrip" "DataGrip.app";
          ".local/bin/dataspell" = mkMacLauncher "dataspell" "DataSpell.app";
          ".local/bin/goland" = mkMacLauncher "goland" "GoLand.app";
          ".local/bin/idea" = mkMacLauncher "idea" "IntelliJ IDEA.app";
          ".local/bin/pycharm" = mkMacLauncher "pycharm" "PyCharm.app";
          ".local/bin/webstorm" = mkMacLauncher "webstorm" "WebStorm.app";
          ".local/bin/rustrover" = mkMacLauncher "rustrover" "RustRover.app";
        })
        (lib.mkIf (!pkgs.stdenv.isDarwin) {
          ".local/bin/datagrip" = mkLinuxLauncher pkgs.jetbrains.datagrip;
          ".local/bin/dataspell" = mkLinuxLauncher pkgs.jetbrains.dataspell;
          ".local/bin/goland" = mkLinuxLauncher pkgs.jetbrains.goland;
          ".local/bin/idea" = mkLinuxLauncher pkgs.jetbrains.idea;
          ".local/bin/pycharm" = mkLinuxLauncher pkgs.jetbrains.pycharm;
          ".local/bin/webstorm" = mkLinuxLauncher pkgs.jetbrains.webstorm;
          ".local/bin/rustrover" = mkLinuxLauncher pkgs.jetbrains.rust-rover;
        })
      ];
    };
}
