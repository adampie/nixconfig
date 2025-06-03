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

  home.file.".local/bin/nixus" = {
    text = ''
      #!/usr/bin/env zsh
      set -e

      cleanup() {
        rm -rf ./result
      }
      trap cleanup EXIT

      nix flake update
      darwin-rebuild build --flake .#

      diff_output=$(nix store diff-closures /run/current-system ./result)
      if [[ -z "$diff_output" || "$diff_output" == *"no changes"* ]]; then
        echo "No changes detected."
        exit 0
      fi

      echo "$diff_output"
      echo -n "Apply changes? (y/n): "
      read -r ans

      if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        sudo darwin-rebuild switch --flake .#
      fi
    '';
    executable = true;
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}