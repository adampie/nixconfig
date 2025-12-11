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
        "little-snitch"
        "micro-snitch"
        "pixelsnap"
        "slack"
        "spotify"
      ];

    masApps = {
      "Flighty" = 1358823008;
      "Xcode" = 497799835;
    };
  };
}
