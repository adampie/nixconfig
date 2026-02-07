{...}: {
  flake.modules.darwin.security = {
    networking.applicationFirewall = {
      enable = true;
      allowSigned = true;
      allowSignedApp = true;
      enableStealthMode = true;
    };

    security.pam.services.sudo_local.touchIdAuth = true;

    system.defaults = {
      loginwindow = {
        GuestEnabled = false;
        SHOWFULLNAME = true;
      };

      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 0;
      };
    };
  };
}
