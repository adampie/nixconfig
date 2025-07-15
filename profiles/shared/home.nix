{
  lib,
  mkJetBrainsDarwinScript,
  ...
}: let
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
      ".local/bin/idea" = mkJetBrainsDarwinScript "idea" "IntelliJ IDEA.app";
      ".local/bin/pycharm" = mkJetBrainsDarwinScript "pycharm" "PyCharm.app";
      ".local/bin/goland" = mkJetBrainsDarwinScript "goland" "GoLand.app";
      ".local/bin/datagrip" = mkJetBrainsDarwinScript "datagrip" "DataGrip.app";
      ".local/bin/webstorm" = mkJetBrainsDarwinScript "webstorm" "WebStorm.app";

      ".local/bin/nixus" = {
        text = ''
          #!/usr/bin/env zsh
          set -e

          cleanup() {
            rm -rf ./result
          }
          trap cleanup EXIT

          pushd "$HOME/Code/adampie/nixconfig" > /dev/null

          echo "🔄 Fetching latest changes..."
          git fetch --all
          git pull --rebase

          echo "📦 Updating flake inputs..."
          nix flake update
          git add -A

          echo "🔨 Building configuration..."
          darwin-rebuild build --flake .#

          echo ""
          echo "🔍 Analyzing system changes..."
          echo "=================================="

          # Get Nix store changes
          echo "Checking Nix store changes..."
          nix_changes=$(nix store diff-closures /run/current-system ./result)
          has_nix_changes=false
          if [[ -n "$nix_changes" && "$nix_changes" != *"no changes"* ]]; then
            has_nix_changes=true
          fi

          # Check for Homebrew changes
          echo "Checking Homebrew packages..."
          brew_formula_changes=""
          brew_cask_changes=""
          mas_changes=""

          # Check brew formulae
          if command -v brew >/dev/null 2>&1; then
            brew_list=$(brew list --formula 2>/dev/null || echo "")
            if [[ -n "$brew_list" ]]; then
              while IFS= read -r package; do
                [[ -z "$package" ]] && continue
                current=$(brew info --json=v2 "$package" 2>/dev/null | jq -r '.[0].installed[0].version // "unknown"' 2>/dev/null || echo "unknown")
                latest=$(brew info --json=v2 "$package" 2>/dev/null | jq -r '.[0].versions.stable // "unknown"' 2>/dev/null || echo "unknown")
                if [[ "$current" != "$latest" && "$latest" != "unknown" && "$current" != "unknown" ]]; then
                  brew_formula_changes="$brew_formula_changes  $package: $current → $latest"$'\n'
                fi
              done <<< "$brew_list"
            fi

            # Check casks (including greedy updates)
            cask_outdated=$(brew outdated --cask --greedy 2>/dev/null || echo "")
            if [[ -n "$cask_outdated" ]]; then
              while IFS= read -r line; do
                [[ -z "$line" ]] && continue
                # Parse brew outdated output: "cask-name (1.0.0) < 1.0.1"
                cask_name=$(echo "$line" | awk '{print $1}')
                if [[ -n "$cask_name" ]]; then
                  current=$(echo "$line" | sed -E 's/.*\(([^)]+)\).*/\1/')
                  latest=$(echo "$line" | sed -E 's/.* < (.*)$/\1/')
                  if [[ -n "$current" && -n "$latest" ]]; then
                    brew_cask_changes="$brew_cask_changes  $cask_name: $current → $latest"$'\n'
                  else
                    # For greedy casks that may not show version differences
                    brew_cask_changes="$brew_cask_changes  $cask_name: update available"$'\n'
                  fi
                fi
              done <<< "$cask_outdated"
            fi
          fi

          # Check MAS apps for outdated versions
          if command -v mas >/dev/null 2>&1; then
            mas_outdated=$(mas outdated 2>/dev/null || echo "")
            if [[ -n "$mas_outdated" ]]; then
              while IFS= read -r line; do
                [[ -z "$line" ]] && continue
                # Parse mas outdated output: "123456 App Name (1.0.0) < 1.0.1"
                app_name=$(echo "$line" | sed -E 's/^[0-9]+ ([^(]+) \(.*/\1/' | sed 's/ *$//')
                current=$(echo "$line" | sed -E 's/.*\(([^)]+)\).*/\1/')
                latest=$(echo "$line" | sed -E 's/.* < (.*)$/\1/')
                if [[ -n "$app_name" && -n "$current" && -n "$latest" ]]; then
                  mas_changes="$mas_changes  $app_name: $current → $latest"$'\n'
                fi
              done <<< "$mas_outdated"
            fi
          fi

          # Display all changes
          changes_found=false

          if [[ "$has_nix_changes" == true ]]; then
            echo ""
            echo "📦 Nix package changes:"
            echo "$nix_changes"
            changes_found=true
          fi

          if [[ -n "$brew_formula_changes" ]]; then
            echo ""
            echo "🍺 Homebrew formula updates available:"
            echo -n "$brew_formula_changes"
            changes_found=true
          fi

          if [[ -n "$brew_cask_changes" ]]; then
            echo ""
            echo "📱 Homebrew cask updates available:"
            echo -n "$brew_cask_changes"
            changes_found=true
          fi

          if [[ -n "$mas_changes" ]]; then
            echo ""
            echo "🏪 Mac App Store updates available:"
            echo -n "$mas_changes"
            changes_found=true
          fi

          if [[ "$changes_found" == false ]]; then
            echo ""
            echo "✅ No changes detected."
            # Check if flake.lock is staged or modified
            if git status --porcelain | grep -q 'flake.lock'; then
              echo "📝 Committing flake.lock update..."
              
              # Check if 1Password is running and start it if needed
              if ! pgrep -x "1Password" > /dev/null; then
                echo "⚠️  1Password not running, starting it..."
                open -a "1Password"
                echo "⏳ Waiting for 1Password to start..."
                sleep 5
              fi
              
              git add flake.lock
              git commit -m "Flake.lock update $(date '+%Y-%m-%d')"
              git push
              echo "✅ flake.lock changes committed and pushed."
            fi
            popd > /dev/null
            exit 0
          fi

          echo ""
          echo "=================================="
          echo -n "Apply changes? (y/n): "
          read -r ans

          if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
            echo ""
            echo "🚀 Applying changes..."
            sudo darwin-rebuild switch --flake .#

            echo ""
            echo "📝 Committing changes..."
            
            # Check if 1Password is running and start it if needed
            if ! pgrep -x "1Password" > /dev/null; then
              echo "⚠️  1Password not running, starting it..."
              open -a "1Password"
              echo "⏳ Waiting for 1Password to start..."
              sleep 5
            fi
            
            git add -A
            git commit -m "Flake update $(date '+%Y-%m-%d')"
            git push

            echo ""
            echo "✅ Update complete!"
          else
            echo "❌ Changes not applied."
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
