# macOS Software Update settings
{...}: {
  flake.modules.darwin.software-update = {
    system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  };
}
