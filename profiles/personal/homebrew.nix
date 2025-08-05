_: {
  homebrew = {
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
        "lm-studio"
        "micro-snitch"
        "slack"
        "spotify"
      ];

    masApps = {
      "Flighty" = 1358823008;
      "Xcode" = 497799835;
    };
  };
}
