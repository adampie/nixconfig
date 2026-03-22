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
            "claude-code"
            "cleanshot"
            "codex"
            "daisydisk"
            "datagrip"
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
    };
}
