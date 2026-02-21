{
  inputs,
  lib,
  mkJetBrainsDarwinScript,
  pkgs,
  # stablepkgs,
  ...
}: {
  imports = [
    inputs.opt-out.homeManagerModules.default
  ];
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

    file = {
      ".homebrew/brew.env".text = ''
        export HOMEBREW_CASK_OPTS=--require-sha
        export HOMEBREW_NO_AUTO_UPDATE=1
        export HOMEBREW_NO_ENV_HINTS=1
        export HOMEBREW_NO_INSECURE_REDIRECT=1
      '';

      ".hushlogin".text = "";

      ".local/bin/.keep".text = "";
      ".local/bin/datagrip" = mkJetBrainsDarwinScript "datagrip" "DataGrip.app";
      ".local/bin/goland" = mkJetBrainsDarwinScript "goland" "GoLand.app";
      ".local/bin/idea" = mkJetBrainsDarwinScript "idea" "IntelliJ IDEA.app";
      ".local/bin/pycharm" = mkJetBrainsDarwinScript "pycharm" "PyCharm.app";
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

      ".ssh/config".text = ''
        Include ~/.orbstack/ssh/config

        Host *
            IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      '';
    };

    packages = with pkgs; [
      cosign
      curl
      devenv
      fh
      jq
      neovim
      nerd-fonts.hack
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

  programs = {
    ghostty = {
      enable = true;
      package = null; # homebrew
      enableZshIntegration = true;
      settings = {
        auto-update = "off";
        copy-on-select = "clipboard";
        font-family = "Hack Nerd Font Mono";
        keybind = [
          "shift+enter=text:\\n"
        ];
        shell-integration = "zsh";
        theme = "Dracula+";
        window-inherit-working-directory = false;
        window-save-state = "always";
        working-directory = "home";
      };
    };

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
      globalConfig = {
        settings.experimental = true;
        tools = {
          go = "latest";
          nodejs = "lts";
          python = "latest";
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

    zed-editor = {
      enable = true;
      package = null; # homebrew
      mutableUserDebug = true;
      mutableUserKeymaps = true;
      mutableUserSettings = true;
      mutableUserTasks = true;

      extensions = [
        "dracula"
        "git-firefly"
        "nix"
        "toml"
      ];

      userSettings = {
        agent = {
          show_turn_stats = true;
          enable_feedback = false;
          default_model = {
            provider = "zed.dev";
            model = "claude-sonnet-4-6";
          };
          play_sound_when_agent_done = true;
        };
        auto_update = false;
        autosave = "on_focus_change";
        base_keymap = "VSCode";
        buffer_font_family = "Hack Nerd Font Mono";
        buffer_font_size = 13;
        calls = {
          mute_on_join = true;
          share_on_join = false;
        };
        close_on_file_delete = true;
        collaboration_panel = {
          button = false;
        };
        colorize_brackets = true;
        edit_predictions = {
          sweep = {
            privacy_mode = true;
          };
          provider = "zed";
        };
        indent_guides = {
          coloring = "fixed";
        };
        on_last_window_closed = "quit_app";
        outline_panel = {
          button = false;
        };
        private_files = [
          "**/.env*"
          "**/*.cert"
          "**/*.crt"
          "**/*.key"
          "**/*.pem"
          "**/secrets.yml"
        ];
        project_panel = {
          git_status = true;
          folder_icons = true;
          file_icons = true;
          entry_spacing = "standard";
          hide_gitignore = false;
        };
        redact_private_values = true;
        restore_on_file_reopen = false;
        restore_on_startup = "empty_tab";
        tabs = {
          file_icons = false;
          git_status = false;
          show_close_button = "always";
        };
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        terminal = {
          copy_on_select = true;
        };
        theme = {
          dark = "Dracula Solid";
          light = "Dracula Light (Alucard)";
          mode = "system";
        };
        ui_font_size = 16;
        when_closing_with_no_tabs = "close_window";
      };
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      history = {
        save = 1000000;
        size = 1000000;
      };
      historySubstringSearch.enable = true;
      syntaxHighlighting.enable = true;
    };
  };
}
