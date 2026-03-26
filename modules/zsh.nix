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
        initContent = ''
          bindkey '^[[1;5C' forward-word      # Ctrl+Right
          bindkey '^[[1;5D' backward-word     # Ctrl+Left
          bindkey '^[[H' beginning-of-line    # Home
          bindkey '^[[F' end-of-line          # End
          bindkey '^H' backward-kill-word     # Ctrl+Backspace
          bindkey '^[[3;5~' kill-word         # Ctrl+Delete
        '';
      };
    };
}
