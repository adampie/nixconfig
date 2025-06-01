{...}: {
  programs = {
    git = {
      enable = true;
      extraConfig = {init = {defaultBranch = "main";};};
      userName = "Adam Pietrzycki";
    };

    mise = {
      enable = true;
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      autosuggestion.enable = true;
      enable = true;
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
