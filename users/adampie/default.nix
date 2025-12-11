{
  lib,
  pkgs,
  unstablepkgs,
  ...
}: {
  home = {
    username = "adampie";
    homeDirectory = "/Users/adampie";
    stateVersion = "25.11";

    activation = {
      createDirectories = lib.hm.dag.entryAfter ["writeBoundary"] ''
        $DRY_RUN_CMD mkdir -p $HOME/Code
        $DRY_RUN_CMD mkdir -p $HOME/Screenshots
      '';
    };

    sessionVariables = {
      NO_TELEMETRY = "1";
      DO_NOT_TRACK = "1";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
    ];

    file = {
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

      ".local/bin/fetch_all_code" = {
        text = ''
          #!/usr/bin/env zsh
          # This script clones all repositories from specified SCM accounts using ghorg
          set -e

          trap 'echo "Error occurred at line $LINENO. Command: $BASH_COMMAND"' ERR

          scm_name="$1"
          account_type="$2"
          account_name="$3"
          token_name="ghorg - $account_name - $scm_name"

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
            --preserve-dir \
            --skip-archived; then
            echo "Error: Failed to clone $account_name repositories"
            exit 1
          fi

          echo "Successfully cloned $account_name repositories"
        '';
        executable = true;
      };
    };
  };

  home.packages =
    (with pkgs; [
      alejandra
      awscli2
      cosign
      colordiff
      curl
      devenv
      diffutils
      gh
      ghorg
      git
      gnupg
      jq
      ripgrep
      starship
      tldr
      watch
      wget
      yq
    ])
    ++ (with unstablepkgs; [
      mise
      nerd-fonts.jetbrains-mono
    ])
    ++ lib.optionals pkgs.stdenv.isDarwin [
      pkgs.mas
    ];

  programs = {
    git = {
      enable = true;
      settings = {
        init.defaultBranch = "main";
        user.name = "Adam Pietrzycki";
      };
    };

    gpg.enable = true;

    mise = {
      enable = true;
      enableZshIntegration = true;
      package = unstablepkgs.mise;
      globalConfig = {
        settings.experimental = true;
        tools = {
          nodejs = "lts";
          python = "latest";
          go = "latest";
        };
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        "$schema" = "https://starship.rs/config-schema.json";
        add_newline = true;

        character.success_symbol = "[➜](bold green)";

        cmd_duration.format = "[ $duration]($style)";

        package.disabled = true;
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      history = {
        save = 1000000;
        size = 1000000;
      };
      historySubstringSearch.enable = true;
      syntaxHighlighting.enable = true;
    };
  };

  home.file.".config/ghostty/config".text = ''
    theme = Dracula+
    shell-integration = zsh
    copy-on-select = clipboard
    window-save-state = always
    font-family = "JetBrainsMono Nerd Font"
    working-directory = home
    keybind = shift+enter=text:\n
  '';

  home.file.".ssh/config".text = ''
    Include ~/.orbstack/ssh/config

    Host *
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  '';
}
