{ ... }: {
  flake.homeModules.jetbrains =
    { pkgs, lib, ... }:
    let
      mkLauncher = name: app: {
        text = ''
          #!/bin/zsh
          "/Applications/${app}/Contents/MacOS/${name}" "$@" > /dev/null 2>&1 &
        '';
        executable = true;
      };
    in
    {
      home.file = lib.mkIf pkgs.stdenv.isDarwin {
        ".local/bin/datagrip" = mkLauncher "datagrip" "DataGrip.app";
        ".local/bin/goland" = mkLauncher "goland" "GoLand.app";
        ".local/bin/idea" = mkLauncher "idea" "IntelliJ IDEA.app";
        ".local/bin/pycharm" = mkLauncher "pycharm" "PyCharm.app";
        ".local/bin/webstorm" = mkLauncher "webstorm" "WebStorm.app";
      };
    };
}
