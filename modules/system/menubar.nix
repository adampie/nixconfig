# macOS Menu Bar Clock settings
{...}: {
  flake.modules.darwin.menubar = {
    system.defaults.menuExtraClock.ShowSeconds = true;
  };
}
