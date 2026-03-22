{ ... }:
{
  flake.darwinModules.defaults =
    { ... }:
    {
      system.defaults = {
        NSGlobalDomain = {
          "com.apple.mouse.tapBehavior" = 1;
          "com.apple.swipescrolldirection" = false;
          AppleShowAllFiles = true;
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticInlinePredictionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;
          NSDocumentSaveNewDocumentsToCloud = false;
          NSWindowShouldDragOnGesture = true;
          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
        };

        SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

        CustomUserPreferences = {
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
            "28" = {
              enabled = false;
            }; # Save picture of screen as a file
            "29" = {
              enabled = false;
            }; # Copy picture of screen to the clipboard
            "30" = {
              enabled = false;
            }; # Save picture of selected area as a file
            "31" = {
              enabled = false;
            }; # Copy picture of selected area to the clipboard
            "184" = {
              enabled = false;
            }; # Screenshot and recording settings
          };
        };

        dock = {
          autohide = true;
          autohide-time-modifier = 0.4;
          mru-spaces = false;
          show-recents = false;
          tilesize = 30;
          wvous-bl-corner = 1;
          wvous-br-corner = 1;
          wvous-tl-corner = 1;
          wvous-tr-corner = 1;
          persistent-apps = [ ];
          persistent-others = [ ];
        };

        finder = {
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

        loginwindow = {
          GuestEnabled = false;
          SHOWFULLNAME = true;
        };

        menuExtraClock.ShowSeconds = true;

        screensaver = {
          askForPassword = true;
          askForPasswordDelay = 0;
        };

        screencapture.location = "~/Screenshots";

        trackpad.Clicking = true;

        WindowManager = {
          EnableStandardClickToShowDesktop = false;
          EnableTiledWindowMargins = false;
        };
      };

      networking.applicationFirewall = {
        enable = true;
        allowSigned = true;
        allowSignedApp = true;
        enableStealthMode = true;
      };

      security.pam.services.sudo_local.touchIdAuth = true;
    };
}
