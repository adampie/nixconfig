{ ... }:
{
  flake.homeModules.pi =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.llm-agents.pi ];
    };
}
