{ ... }:
{
  flake.homeModules.zsh =
    { ... }:
    {
      programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        enableCompletion = true;
        history = {
          save = 1000000;
          size = 1000000;
        };
        historySubstringSearch.enable = true;
        syntaxHighlighting.enable = true;
      };
    };
}
