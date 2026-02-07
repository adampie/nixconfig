{pkgs, ...}: {
  networking.hostName = "Adams-MacBook-Pro";

  system.defaults.screencapture.location = "/Users/adampie/Screenshots";

  environment.systemPackages = with pkgs; [
    gh
    ghorg
    neofetch
    osv-scanner
  ];

  homebrew = {
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
  };
}
