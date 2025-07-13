{...}: {
  homebrew = {
    casks =
      map (name: {
        inherit name;
        greedy = true;
      }) [
        "claude"
        "daisydisk"
        "discord"
        "little-snitch"
        "lm-studio"
        "micro-snitch"
      ];

    masApps = {
      "Flighty" = 1358823008;
      "Xcode" = 497799835;
    };
  };
}
