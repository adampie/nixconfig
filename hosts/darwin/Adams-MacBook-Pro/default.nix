{ ... }:
{
  imports = [
    ../../../modules/darwin/default.nix
  ];

  host = {
    username = "adampie";
    hostname = "Adams-MacBook-Pro";
    platform = "darwin";
    systemType = "personal";
    architecture = "aarch64";
  };

  home-manager.users.adampie =
    {
      pkgs,
      stablepkgs,
      lib,
      mkJetBrainsDarwinScript,
      ...
    }:
    {
      imports = [
        (import ../../../users/adampie/personal.nix {
          inherit
            pkgs
            stablepkgs
            lib
            mkJetBrainsDarwinScript
            ;
        })
      ];

      home.packages =
        (with pkgs; [
          gh
          ghorg
          osv-scanner
        ])
        ++ (with stablepkgs; [
          neofetch
        ]);
    };

  services.aerospace = {
    enable = false;
    settings = { };
  };

  homebrew = {
    enable = true;

    taps = [
      {
        name = "adampie/homebrew-tap";
        clone_target = "git@github.com:adampie/homebrew-tap.git";
        force_auto_update = true;
      }
      {
        name = "adampie/homebrew-tap-private";
        clone_target = "git@github.com:adampie/homebrew-tap-private.git";
        force_auto_update = true;
      }
    ];

    brews = [
      "anomalyco/tap/opencode"
      "gemini-cli"
      "mas"
    ];

    casks =
      map
        (name: {
          inherit name;
          greedy = true;
        })
        [
          "adampie/tap-private/qq"
          "1password"
          "1password-cli"
          "beyond-compare"
          "claude"
          "claude-code"
          "cleanshot"
          "codex"
          "datagrip"
          "daisydisk"
          "discord"
          "ghostty"
          "goland"
          "intellij-idea"
          "little-snitch"
          "micro-snitch"
          "mullvad-vpn"
          "orbstack"
          "pixelsnap"
          "proxyman"
          "pycharm"
          "slack"
          "spotify"
          "superwhisper"
          "tower"
          "webstorm"
          "zed"
        ];

    masApps = {
      "1Password for Safari" = 1569813296;
      "Flighty" = 1358823008;
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
