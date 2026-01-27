# macOS Privacy settings
{...}: {
  flake.modules.darwin.privacy = {
    system.defaults.CustomUserPreferences = {
      "com.apple.AdLib" = {allowApplePersonalizedAdvertising = false;};
      "com.apple.AppleIntelligenceReport" = {reportDuration = 0;};
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
    };
  };
}
