{...}: {
  flake.modules.darwin.dock = {
    system.defaults.dock = {
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
  };
}
