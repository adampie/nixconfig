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
    ...
  }: {
    imports = [
      (import ../../users/adampie/personal.nix {
        inherit pkgs unstablepkgs;
      })
    ];

    home.packages =
      (with pkgs; [
        alejandra
        awscli2
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
        goreleaser
        jq
        neofetch
        ripgrep
        starship
        tldr
        watch
        wget
        yq
      ])
      ++ (with unstablepkgs; [
        mise
        nerd-fonts.jetbrains-mono
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
      "opa"
      "yara-x"
    ];

    casks =
      map (name: {
        inherit name;
        greedy = true;
      }) [
        "1password-cli"
        "1password"
        "beyond-compare"
        "cleanshot"
        "cursor"
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
      "Xcode" = 497799835;
    };

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };

  networking.applicationFirewall = {
    enable = true;
    allowSigned = true;
    allowSignedApp = true;
    enableStealthMode = true;
  };
}
