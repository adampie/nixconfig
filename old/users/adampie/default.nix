{
  inputs,
  lib,
  mkJetBrainsDarwinScript,
  pkgs,
  # stablepkgs,
  ...
}:
{
  imports = [
    inputs.opt-out.homeManagerModules.default
  ];
  home = {
    username = "adampie";
    homeDirectory = "/Users/adampie";
    stateVersion = "25.11";

    activation = {
      createDirectories = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD mkdir -p $HOME/Code
        $DRY_RUN_CMD mkdir -p $HOME/Screenshots
      '';
    };

    file = {
      ".hushlogin".text = "";

      ".local/bin/.keep".text = "";
      ".local/bin/datagrip" = mkJetBrainsDarwinScript "datagrip" "DataGrip.app";
      ".local/bin/goland" = mkJetBrainsDarwinScript "goland" "GoLand.app";
      ".local/bin/idea" = mkJetBrainsDarwinScript "idea" "IntelliJ IDEA.app";
      ".local/bin/pycharm" = mkJetBrainsDarwinScript "pycharm" "PyCharm.app";
      ".local/bin/webstorm" = mkJetBrainsDarwinScript "webstorm" "WebStorm.app";
    };

    packages = with pkgs; [
      cosign
      curl
      devenv
      fh
      jq

      nil
      nixd
      ripgrep
      wget
      yq
    ];

    sessionPath = [
      "$HOME/.local/bin"
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
    ];
  };
}
