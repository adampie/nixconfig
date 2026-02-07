{...}: {
  flake.modules.homeManager.starship = {
    programs.starship = {
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
  };
}
