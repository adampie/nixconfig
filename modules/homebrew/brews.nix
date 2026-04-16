{ ... }:
{
  flake.darwinModules.homebrewBrews =
    { ... }:
    {
      homebrew.brews = [
        "adampie/tap/macos-diff"
        "ccusage"
        "gemini-cli"
        "mas"
      ];
    };
}
