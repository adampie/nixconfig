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

  home.file.".local/bin/fetch_all_code" = {
    text = ''
      #!/usr/bin/env zsh
      # This script clones all repositories from specified SCM accounts using ghorg
      set -e

      trap 'echo "Error occurred at line $LINENO. Command: $BASH_COMMAND"' ERR

      CLONE_PATH="$HOME/Code"
      COMMON_ARGS="--protocol=ssh --path=$CLONE_PATH --include-submodules --fetch-all --skip-archived"

      scm_name="$1"
      account_type="$2"
      account_name="$3"
      token_name="ghorg - $account_name"

      echo "Cloning $account_name repositories..."

      # Get token from 1Password
      if ! token=$(op item get --vault 'Private' "$token_name" --fields=credential --reveal); then
        echo "Error: Failed to retrieve token for $account_name from 1Password"
        exit 1
      fi

      if ! ghorg clone "$account_name" \
        --scm="$scm_name" \
        --token="$token" \
        --clone-type="$account_type" \
        $COMMON_ARGS; then
        echo "Error: Failed to clone $account_name repositories"
        exit 1
      fi

      echo "Successfully cloned $account_name repositories"
    '';
    executable = true;
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
