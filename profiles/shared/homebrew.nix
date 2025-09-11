_: {
  homebrew = {
    enable = true;

    taps = [
      {
        name = "adampie/homebrew-tap";
        clone_target = "git@github.com:adampie/homebrew-tap.git";
        force_auto_update = true;
      }
    ];

    brews = [
      "aider"
      "codex"
      "mas"
    ];

    casks =
      map (name: {
        inherit name;
        greedy = true;
      }) [
        "1password-cli"
        "beyond-compare"
        "cleanshot"
        "claude-code"
        "cursor"
        "datagrip"
        "ghostty"
        "goland"
        "intellij-idea"
        "orbstack"
        "pixelsnap"
        "proxyman"
        "pycharm"
        "superwhisper"
        "tower"
        "webstorm"
        "zen"
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
