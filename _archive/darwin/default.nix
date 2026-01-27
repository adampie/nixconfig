{config, ...}: {
  imports = [
    ../host/options.nix
  ];

  config = let
    inherit (config.host) username;
  in {
    nix.enable = false;

    home-manager = {
      overwriteBackup = true;
      backupFileExtension = "backup";
    };

    system = {
      stateVersion = 6;
      primaryUser = username;
      defaults = {
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
          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
        };

        SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

        CustomUserPreferences = {
          "com.apple.AdLib" = {allowApplePersonalizedAdvertising = false;};
          "com.apple.AppleIntelligenceReport" = {reportDuration = 0;};
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
              # Save picture of screen as a file
              enabled = false;
            };
            "29" = {
              # Copy picture of screen to the clipboard
              enabled = false;
            };
            "30" = {
              # Save picture of selected area as a file
              enabled = false;
            };
            "31" = {
              # Copy picture of selected area to the clipboard
              enabled = false;
            };
            "184" = {
              # Screenshot and recording settings
              enabled = false;
            };
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
          persistent-apps = [];
          persistent-others = [];
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

        screencapture.location = "/Users/${username}/Screenshots";

        trackpad.Clicking = true;

        WindowManager = {
          EnableStandardClickToShowDesktop = false;
          EnableTiledWindowMargins = false;
        };
      };
    };

    users.users.${username} = {
      name = username;
      home = "/Users/${username}";
    };

    networking = {
      hostName = config.host.hostname;
      applicationFirewall = {
        enable = true;
        allowSigned = true;
        allowSignedApp = true;
        enableStealthMode = true;
      };
    };
    security.pam.services.sudo_local.touchIdAuth = true;
  };
}
