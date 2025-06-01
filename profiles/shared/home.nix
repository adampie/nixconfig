{lib, ...}: let
  mkJetBrainsScript = appName: appBinary: {
    text = ''
      #!/bin/sh
      open -na "${appBinary}" --args "$@"
    '';
    executable = true;
  };
in {
  home.stateVersion = "25.05";

  home.activation.createDirectories = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p $HOME/Code
    $DRY_RUN_CMD mkdir -p $HOME/Screenshots
  '';

  home.sessionVariables = {
    NO_TELEMETRY = "1";
    DO_NOT_TRACK = "1";
  };

  home.file.".homebrew/brew.env".text = ''
    export HOMEBREW_NO_ANALYTICS=1
    export HOMEBREW_CASK_OPTS=--require-sha
    export HOMEBREW_NO_AUTO_UPDATE=1
    export HOMEBREW_NO_ENV_HINTS=1
    export HOMEBREW_NO_INSECURE_REDIRECT=1
  '';

  home.file.".hushlogin".text = "";

  home.file.".local/bin/.keep".text = "";
  home.file.".local/bin/idea" = mkJetBrainsScript "idea" "IntelliJ IDEA.app";
  home.file.".local/bin/pycharm" = mkJetBrainsScript "pycharm" "PyCharm.app";
  home.file.".local/bin/goland" = mkJetBrainsScript "goland" "GoLand.app";
  home.file.".local/bin/datagrip" = mkJetBrainsScript "datagrip" "DataGrip.app";

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
