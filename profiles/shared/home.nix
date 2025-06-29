{lib, ...}: let
  mkJetBrainsScript = appName: appBinary: {
    text = ''
      #!/bin/zsh
      "/Applications/${appBinary}/Contents/MacOS/${appName}" "$@" > /dev/null 2>&1 &
    '';
    executable = true;
  };

  mkClaudeFiles = {
    claudeDir,
    memoryFiles,
    commandFiles,
  }:
    lib.mkMerge [
      {
        ".claude/CLAUDE.md".source = "${claudeDir}/CLAUDE.md";
      }
      (lib.listToAttrs (map (filename: {
          name = ".claude/memories/${filename}.md";
          value = {
            source = "${claudeDir}/${filename}.md";
          };
        })
        memoryFiles))
      (lib.listToAttrs (map (filename: {
          name = ".claude/commands/${filename}.md";
          value = {
            source = "${claudeDir}/commands/${filename}.md";
          };
        })
        commandFiles))
    ];
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

  home.sessionPath = [
    "$HOME/.local/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  home.activation.createClaudeDirectory = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p $HOME/.claude
    $DRY_RUN_CMD mkdir -p $HOME/.claude/memories
    $DRY_RUN_CMD mkdir -p $HOME/.claude/commands
  '';

  # Shared home files
  home.file = lib.mkMerge [
    {
      ".homebrew/brew.env".text = ''
        export HOMEBREW_NO_ANALYTICS=1
        export HOMEBREW_CASK_OPTS=--require-sha
        export HOMEBREW_NO_AUTO_UPDATE=1
        export HOMEBREW_NO_ENV_HINTS=1
        export HOMEBREW_NO_INSECURE_REDIRECT=1
      '';

      ".hushlogin".text = "";

      ".local/bin/.keep".text = "";
      ".local/bin/idea" = mkJetBrainsScript "idea" "IntelliJ IDEA.app";
      ".local/bin/pycharm" = mkJetBrainsScript "pycharm" "PyCharm.app";
      ".local/bin/goland" = mkJetBrainsScript "goland" "GoLand.app";
      ".local/bin/datagrip" = mkJetBrainsScript "datagrip" "DataGrip.app";
      ".local/bin/webstorm" = mkJetBrainsScript "webstorm" "WebStorm.app";

      ".local/bin/nixus" = {
        text = ''
          #!/usr/bin/env zsh
          set -e

          cleanup() {
            rm -rf ./result
          }
          trap cleanup EXIT

          pushd "$HOME/Code/adampie/nixconfig" > /dev/null

          nix flake update
          git add -A
          darwin-rebuild build --flake .#

          diff_output=$(nix store diff-closures /run/current-system ./result)
          if [[ -z "$diff_output" || "$diff_output" == *"no changes"* ]]; then
            echo "No changes detected."
            popd > /dev/null
            exit 0
          fi

          echo "$diff_output"
          echo -n "Apply changes? (y/n): "
          read -r ans

          if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
            sudo darwin-rebuild switch --flake .#
            git add -A
            git commit -m "Flake update"
            git push
          fi
          
          popd > /dev/null
        '';
        executable = true;
      };

      ".local/bin/fetch_all_code" = {
        text = ''
          #!/usr/bin/env zsh
          # This script clones all repositories from specified SCM accounts using ghorg
          set -e

          trap 'echo "Error occurred at line $LINENO. Command: $BASH_COMMAND"' ERR

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
            --protocol=ssh \
            --path=$HOME/Code \
            --include-submodules \
            --fetch-all \
            --skip-archived; then
            echo "Error: Failed to clone $account_name repositories"
            exit 1
          fi

          echo "Successfully cloned $account_name repositories"
        '';
        executable = true;
      };
    }
    (mkClaudeFiles {
      claudeDir = ../../claude;
      memoryFiles = [
        "cdk"
        "cicd"
        "docker"
        "golang"
        "javascript"
        "python"
        "security"
        "shell"
        "terraform"
      ];
      commandFiles = [];
    })
  ];
}
