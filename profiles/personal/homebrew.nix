_: {
  homebrew = {
    taps = [
      {
        name = "adampie/homebrew-tap-private";
        clone_target = "git@github.com:adampie/homebrew-tap-private.git";
        force_auto_update = true;
      }
    ];

    casks =
      map (name: {
        inherit name;
        greedy = true;
      }) [
        "1password"
        "claude"
        "daisydisk"
        "discord"
        "ghidra"
        "little-snitch"
        "lm-studio"
        "micro-snitch"
        "slack"
        "spotify"
        "temurin"
        "wireshark-app"
      ];

    masApps = {
      "Flighty" = 1358823008;
      "Xcode" = 497799835;
    };
  };
}
