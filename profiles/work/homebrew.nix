{...}: {
  homebrew.casks = map (name: {
    inherit name;
    greedy = true;
  }) [];
  homebrew.masApps = {};
}
