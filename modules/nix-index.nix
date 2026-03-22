{ inputs, ... }:
{
  flake.homeModules.nixIndex =
    { ... }:
    {
      imports = [
        inputs.nix-index-database.homeModules.nix-index
      ];
      programs.nix-index-database.comma.enable = true;
      programs.command-not-found.enable = false;
    };
}
