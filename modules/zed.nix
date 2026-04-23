{ ... }:
{
  flake.homeModules.zed =
    { pkgs, ... }:
    {
      programs.zed-editor = {
        enable = true;
        package = if pkgs.stdenv.isDarwin then null else pkgs.zed-editor;
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
          collaboration_panel.button = false;
          colorize_brackets = true;
          disable_ai = true;
          features.edit_prediction_provider = "none";
          indent_guides.coloring = "fixed";
          on_last_window_closed = "quit_app";
          outline_panel.button = false;
          private_files = [
            "**/.env*"
            "**/*.cert"
            "**/*.crt"
            "**/*.key"
            "**/*.pem"
            "**/secrets.yml"
          ];
          project_panel = {
            entry_spacing = "standard";
            file_icons = true;
            folder_icons = true;
            git_status = true;
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
          terminal.copy_on_select = true;
          theme = {
            dark = "Dracula Solid";
            light = "Dracula Light (Alucard)";
            mode = "system";
          };
          ui_font_size = 16;
          when_closing_with_no_tabs = "close_window";
        };
      };
    };
}
