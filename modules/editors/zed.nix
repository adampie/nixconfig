# Zed editor configuration
{...}: {
  flake.modules.homeManager.zed = {
    programs.zed-editor = {
      enable = true;
      package = null; # installed via homebrew
      mutableUserDebug = true;
      mutableUserKeymaps = true;
      mutableUserSettings = false;
      mutableUserTasks = true;

      extensions = [
        "nix"
        "dracula"
        "toml"
        "git-firefly"
      ];

      userSettings = {
        auto_update = false;
        telemetry = {
          diagnostics = false;
          metrics = false;
        };

        calls = {
          mute_on_join = true;
          share_on_join = false;
        };

        theme = {
          mode = "system";
          light = "Dracula Light (Alucard)";
          dark = "Dracula Solid";
        };

        # Personal preference: disable edit prediction
        features = {
          edit_prediction_provider = "none";
        };

        base_keymap = "VSCode";
        buffer_font_family = "Hack Nerd Font Mono";
        buffer_font_size = 13;
        ui_font_size = 16;
        colorize_brackets = true;
        indent_guides = {
          coloring = "fixed";
        };

        restore_on_startup = "none";
        restore_on_file_reopen = false;
        close_on_file_delete = true;
        when_closing_with_no_tabs = "close_window";
        on_last_window_closed = "quit_app";
        autosave = "on_focus_change";
        redact_private_values = true;
        private_files = [
          "**/.env*"
          "**/*.pem"
          "**/*.key"
          "**/*.cert"
          "**/*.crt"
          "**/secrets.yml"
        ];

        agent = {
          play_sound_when_agent_done = true;
        };

        tabs = {
          git_status = false;
          file_icons = false;
          show_close_button = "always";
        };

        terminal = {
          copy_on_select = true;
        };

        lsp = {
          nil = {
            initialization_options = {
              formatting = {
                command = [
                  "alejandra"
                  "--quiet"
                  "--"
                ];
              };
            };
          };
        };
      };
    };
  };
}
