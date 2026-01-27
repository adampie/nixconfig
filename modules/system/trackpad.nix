# macOS Trackpad settings
{...}: {
  flake.modules.darwin.trackpad = {
    system.defaults.trackpad.Clicking = true;
  };
}
