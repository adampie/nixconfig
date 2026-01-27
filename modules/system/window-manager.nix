# macOS Window Manager settings
{...}: {
  flake.modules.darwin.window-manager = {
    system.defaults.WindowManager = {
      EnableStandardClickToShowDesktop = false;
      EnableTiledWindowMargins = false;
    };
  };
}
