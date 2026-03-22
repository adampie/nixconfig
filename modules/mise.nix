{ ... }:
{
  flake.homeModules.mise =
    { ... }:
    {
      programs.mise = {
        enable = true;
        enableZshIntegration = true;
        globalConfig = {
          settings.experimental = true;
          tools = {
            go = "latest";
            hk = "latest";
            nodejs = "lts";
            pkl = "latest";
            python = "latest";
          };
        };
      };
    };
}
