{...}: let
  mkJetBrainsDarwinScript = appName: appBinary: {
    text = ''
      #!/bin/zsh
      "/Applications/${appBinary}/Contents/MacOS/${appName}" "$@" > /dev/null 2>&1 &
    '';
    executable = true;
  };
in {
  flake.modules.homeManager.jetbrains = {
    home.file = {
      ".local/bin/.keep".text = "";
      ".local/bin/idea" = mkJetBrainsDarwinScript "idea" "IntelliJ IDEA.app";
      ".local/bin/pycharm" = mkJetBrainsDarwinScript "pycharm" "PyCharm.app";
      ".local/bin/goland" = mkJetBrainsDarwinScript "goland" "GoLand.app";
      ".local/bin/datagrip" = mkJetBrainsDarwinScript "datagrip" "DataGrip.app";
      ".local/bin/webstorm" = mkJetBrainsDarwinScript "webstorm" "WebStorm.app";
    };
  };
}
