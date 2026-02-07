{...}: {
  flake.modules.darwin.privacy = {
    system.defaults.CustomUserPreferences = {
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
      };
      "com.apple.AppleIntelligenceReport" = {
        reportDuration = 0;
      };
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.Safari" = {
        AutoFillCreditCardData = false;
        AutoFillFromAddressBook = false;
        AutoFillFromiCloudKeychain = false;
        AutoFillMiscellaneousForms = false;
        AutoFillPasswords = false;
        UseHTTPSOnly = true;
        DeveloperMenuVisibility = true;
        ShowFullURLInSmartSearchField = true;
      };
      AppleSymbolicHotKeys = {
        "28" = {enabled = false;};
        "29" = {enabled = false;};
        "30" = {enabled = false;};
        "31" = {enabled = false;};
        "184" = {enabled = false;};
      };
    };
  };
}
