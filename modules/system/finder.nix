# macOS Finder configuration
{...}: {
  flake.modules.darwin.finder = {
    system.defaults.finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXDefaultSearchScope = "SCcf";
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv";
      FXRemoveOldTrashItems = true;
      NewWindowTarget = "Home";
      QuitMenuItem = true;
      ShowPathbar = true;
    };
  };
}
