{ ... }:
{
  flake.darwinModules.homebrewBrews =
    { ... }:
    {
      homebrew.brews = [
        "ccusage"
        "gemini-cli"
        "mas"
      ];
    };
}
