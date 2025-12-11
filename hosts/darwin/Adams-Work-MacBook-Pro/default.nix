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
    unstablepkgs,
    lib,
    mkJetBrainsDarwinScript,
    ...
  }: {
    imports = [
      (import ../../../users/adampie/work.nix {
        inherit pkgs unstablepkgs lib mkJetBrainsDarwinScript;
      })
    ];

    home.packages =
      (with pkgs; [
        alejandra
        aws-vault
        awscli2
        cosign
        colordiff
        curl
        devenv
        diffutils
        dive
        fh
        gettext
        gh
        ghorg
        git
        glab
        gnupg
        jq
        just
        kubectl
        kubernetes-helm
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
        "claude-code"
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
