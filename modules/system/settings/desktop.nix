{...}: {
  flake.modules.darwin.desktop = {
    system.defaults = {
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

      trackpad.Clicking = true;

      menuExtraClock.ShowSeconds = true;

      WindowManager = {
        EnableStandardClickToShowDesktop = false;
        EnableTiledWindowMargins = false;
      };
    };
  };
}
