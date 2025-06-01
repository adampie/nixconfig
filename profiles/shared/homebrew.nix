{...}: {
  homebrew = {
    enable = true;

    brews = [
      "mas"
    ];

    casks = [
      "1password"
      "1password-cli"
      "beyond-compare"
      "cleanshot"
      "cursor"
      "datagrip"
      "ghostty"
      "goland"
      "intellij-idea"
      "orbstack"
      "proxyman"
      "pycharm"
      "slack"
      "superwhisper"
      "tower"
    ];

    masApps = {
      "1Password for Safari" = 1569813296;
      "Kagi for Safari" = 1622835804;
      "Wipr 2" = 1662217862;
    };

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
