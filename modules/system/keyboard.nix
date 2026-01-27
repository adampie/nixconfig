# macOS Keyboard shortcuts - disable screenshot shortcuts
{...}: {
  flake.modules.darwin.keyboard = {
    system.defaults.CustomUserPreferences.AppleSymbolicHotKeys = {
      "28" = {
        # Save picture of screen as a file
        enabled = false;
      };
      "29" = {
        # Copy picture of screen to the clipboard
        enabled = false;
      };
      "30" = {
        # Save picture of selected area as a file
        enabled = false;
      };
      "31" = {
        # Copy picture of selected area to the clipboard
        enabled = false;
      };
      "184" = {
        # Screenshot and recording settings
        enabled = false;
      };
    };
  };
}
