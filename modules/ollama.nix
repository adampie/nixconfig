{ ... }:
{
  flake.nixosModules.ollama =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.ollama-cuda ];
    };
}
