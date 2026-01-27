# macOS Login Window settings
{...}: {
  flake.modules.darwin.loginwindow = {
    system.defaults.loginwindow = {
      GuestEnabled = false;
      SHOWFULLNAME = true;
    };
  };
}
