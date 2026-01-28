{...}: {
  flake.modules.homeManager.shell = {...}: {
    programs = {
      starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          "$schema" = "https://starship.rs/config-schema.json";
          add_newline = true;
          character.success_symbol = "[➜](bold green)";
          cmd_duration.format = "[ $duration]($style)";
          package.disabled = true;
        };
      };

      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        history = {
          save = 1000000;
          size = 1000000;
        };
        historySubstringSearch.enable = true;
        syntaxHighlighting.enable = true;
      };
    };
  };
}
