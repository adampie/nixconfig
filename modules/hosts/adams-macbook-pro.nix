# Adams-MacBook-Pro host configuration
{inputs, ...}:
let
  hostname = "Adams-MacBook-Pro";
  username = "adampie";
  system = "aarch64-darwin";
in {
  flake.darwinConfigurations.${hostname} = inputs.nix-darwin.lib.darwinSystem {
    inherit system;

    specialArgs = {
      inherit inputs;
      stablepkgs = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
    };

    modules = [
      # Home Manager integration
      inputs.home-manager.darwinModules.home-manager
      {
        nixpkgs.config.allowUnfree = true;
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit inputs;};
        };
      }

      # System configuration modules (darwin)
      inputs.self.modules.darwin.nix-daemon
      inputs.self.modules.darwin.home-manager-config
      inputs.self.modules.darwin.state-version
      inputs.self.modules.darwin.macos-defaults
      inputs.self.modules.darwin.software-update
      inputs.self.modules.darwin.privacy
      inputs.self.modules.darwin.safari
      inputs.self.modules.darwin.keyboard
      inputs.self.modules.darwin.dock
      inputs.self.modules.darwin.finder
      inputs.self.modules.darwin.loginwindow
      inputs.self.modules.darwin.menubar
      inputs.self.modules.darwin.screensaver
      inputs.self.modules.darwin.screenshots
      inputs.self.modules.darwin.trackpad
      inputs.self.modules.darwin.window-manager
      inputs.self.modules.darwin.security

      # User configuration
      {
        system.primaryUser = username;
        users.users.${username} = {
          name = username;
          home = "/Users/${username}";
        };

        # Home Manager user configuration
        home-manager.users.${username} = {
          pkgs,
          stablepkgs,
          ...
        }: {
          imports = [
            # Home base
            inputs.self.modules.homeManager.home-base

            # Shell
            inputs.self.modules.homeManager.zsh
            inputs.self.modules.homeManager.starship

            # Development
            inputs.self.modules.homeManager.git
            inputs.self.modules.homeManager.mise
            inputs.self.modules.homeManager.devenv
            inputs.self.modules.homeManager.jetbrains

            # Editors & Terminal
            inputs.self.modules.homeManager.zed
            inputs.self.modules.homeManager.ghostty

            # Security
            inputs.self.modules.homeManager.ssh
            inputs.self.modules.homeManager.gpg

            # Packages
            inputs.self.modules.homeManager.cli-tools
            inputs.self.modules.homeManager.fonts

            # Scripts
            inputs.self.modules.homeManager.fetch-all-code

            # Privacy
            inputs.self.modules.homeManager.disable-telemetry
            inputs.self.modules.homeManager.homebrew-environment
          ];

          # Host-specific packages
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
      }

      # Homebrew configuration
      {
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

          casks = map (name: {
            inherit name;
            greedy = true;
          }) [
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
    ];
  };
}
