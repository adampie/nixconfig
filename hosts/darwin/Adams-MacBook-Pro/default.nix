{...}: {
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

  home-manager.users.adampie = {
    pkgs,
    unstablepkgs,
    lib,
    mkJetBrainsDarwinScript,
    ...
  }: {
    imports = [
      (import ../../../users/adampie/personal.nix {
        inherit pkgs unstablepkgs lib mkJetBrainsDarwinScript;
      })
    ];

    home.packages =
      (with pkgs; [
        alejandra
        cosign
        colordiff
        curl
        devenv
        diffutils
        fh
        gh
        ghorg
        git
        gnupg
        jq
        neofetch
        nil
        nixd
        ripgrep
        starship
        tldr
        watch
        wget
        yq
      ])
      ++ (with unstablepkgs; [
        mise
        nerd-fonts.hack
      ])
      ++ lib.optionals pkgs.stdenv.isDarwin [
        pkgs.mas
      ];
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
      "codex"
      "gemini-cli"
      "mas"
    ];

    casks =
      map (name: {
        inherit name;
        greedy = true;
      }) [
        "1password-cli"
        "1password"
        "beyond-compare"
        "claude"
        "claude-code"
        "cleanshot"
        "daisydisk"
        "datagrip"
        "discord"
        "ghostty"
        "goland"
        "intellij-idea"
        "little-snitch"
        "micro-snitch"
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
        "zen"
      ];

    masApps = {
      "1Password for Safari" = 1569813296;
      "Flighty" = 1358823008;
      "Kagi for Safari" = 1622835804;
      "Wipr 2" = 1662217862;
      # "Xcode" = 497799835;
    };

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
