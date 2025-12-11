_: {
  imports = [
    ../../modules/darwin/default.nix
  ];

  host = {
    username = "adampie";
    hostname = "Adams-Work-MacBook-Pro";
    platform = "darwin";
    systemType = "work";
    architecture = "aarch64";
  };

  home-manager.users.adampie = import ../../users/adampie/work.nix;

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
      "codex"
      "gemini-cli"
      "mas"
      "opa"
      "yara-x"
    ];

    casks =
      map (name: {
        inherit name;
        greedy = true;
      }) [
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
        "superwhisper"
        "tower"
        "webstorm"
        "zed"
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

  system.defaults = {};
}
