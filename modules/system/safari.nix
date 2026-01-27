# Safari browser settings
{...}: {
  flake.modules.darwin.safari = {
    system.defaults.CustomUserPreferences."com.apple.Safari" = {
      AutoFillCreditCardData = false;
      AutoFillFromAddressBook = false;
      AutoFillFromiCloudKeychain = false;
      AutoFillMiscellaneousForms = false;
      AutoFillPasswords = false;
      UseHTTPSOnly = true;
      DeveloperMenuVisibility = true;
      ShowFullURLInSmartSearchField = true;
    };
  };
}
