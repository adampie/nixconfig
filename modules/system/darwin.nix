{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    host = {
      username = lib.mkOption {
        type = lib.types.str;
        description = "The primary username for this host";
      };

      hostname = lib.mkOption {
        type = lib.types.str;
        description = "The hostname for this system";
      };

      homeProfile = lib.mkOption {
        type = lib.types.path;
        description = "Path to the home-manager profile to use";
      };
    };
  };

  config = let
    username = config.host.username;
  in {
    nix.enable = false;
    system.stateVersion = 6;

    users.users.${username} = {
      name = username;
      home = "/Users/${username}";
    };

    system.primaryUser = username;
    home-manager.backupFileExtension = "backup";
    home-manager.users.${username} = import config.host.homeProfile;
    networking.hostName = config.host.hostname;

    security.pam.services.sudo_local.touchIdAuth = true;
    system.defaults = lib.mkDefault {
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

      SoftwareUpdate = {
        AutomaticallyInstallMacOSUpdates = true;
      };

      CustomUserPreferences = {
        "com.apple.AdLib" = {allowApplePersonalizedAdvertising = false;};
        "com.apple.AppleIntelligenceReport" = {reportDuration = 0;};
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
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

        persistent-apps = [
          {
            app = "/System/Applications/Launchpad.app";
          }
        ];
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

      menuExtraClock = {ShowSeconds = true;};

      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 0;
      };

      screencapture = {
        location = "/Users/${username}/Screenshots";
      };

      trackpad = {Clicking = true;};

      WindowManager = {
        EnableStandardClickToShowDesktop = false;
        EnableTiledWindowMargins = false;
      };
    };
  };
}
