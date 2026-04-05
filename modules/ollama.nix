{ ... }:
{
  flake.nixosModules.ollama =
    { ... }:
    {
      services.ollama = {
        enable = true;
        acceleration = "cuda";
      };
    };
}
