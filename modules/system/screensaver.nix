# macOS Screensaver settings
{...}: {
  flake.modules.darwin.screensaver = {
    system.defaults.screensaver = {
      askForPassword = true;
      askForPasswordDelay = 0;
    };
  };
}
