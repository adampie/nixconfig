{ ... }:
{
  flake.homeModules.forge =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.llm-agents.forge ];
    };
}
