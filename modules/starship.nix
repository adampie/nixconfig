{ ... }:
{
  flake.homeModules.starship =
    { ... }:
    {
      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          "$schema" = "https://starship.rs/config-schema.json";
          command_timeout = 1000;
          add_newline = true;
          character.success_symbol = "[➜](bold green)";
          cmd_duration.format = "[ $duration]($style)";
          package.disabled = true;
        };
      };
    };
}
