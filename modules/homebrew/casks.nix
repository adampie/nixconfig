{ ... }:
{
  flake.darwinModules.homebrewCasks =
    { ... }:
    {
      homebrew.casks =
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
            "claude-code@latest"
            "cleanshot"
            "codex"
            "daisydisk"
            "datagrip"
            "dataspell"
            "discord"
            "ghostty"
            "goland"
            "intellij-idea"
            "launchbar"
            "little-snitch"
            "micro-snitch"
            "mullvad-vpn"
            "orbstack"
            "pixelsnap"
            "proxyman"
            "pycharm"
            "rustrover"
            "slack"
            "spotify"
            "superwhisper"
            "tower"
            "webstorm"
            "zed"
          ];
    };
}
