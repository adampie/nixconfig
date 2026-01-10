{...}: {
  imports = [
    ../../../modules/darwin/default.nix
  ];

  host = {
    username = "adampie";
    hostname = "Adams-Work-MacBook-Pro";
    platform = "darwin";
    systemType = "work";
    architecture = "aarch64";
  };

  home-manager.users.adampie = {
    pkgs,
    stablepkgs,
    lib,
    mkJetBrainsDarwinScript,
    ...
  }: {
    imports = [
      (import ../../../users/adampie/work.nix {
        inherit
          pkgs
          stablepkgs
          lib
          mkJetBrainsDarwinScript
          ;
      })
    ];

    home.packages =
      (
        with pkgs; [
          awscli2
          gh
          ghorg
          osv-scanner
        ]
      )
      ++ (with stablepkgs; [
        neofetch
      ]);
  };

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
      # "gemini-cli"
      "mas"
    ];

    casks =
      map
      (name: {
        inherit name;
        greedy = true;
      })
      [
        "1password"
        "1password-cli"
        # "claude-code"
        # "codex"
        # "cursor"
        "beyond-compare"
        "cleanshot"
        "datagrip"
        "ghostty"
        "goland"
        "intellij-idea"
        "orbstack"
        "proxyman"
        "slack"
        # "superwhisper"
        "tower"
        "zed"
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
