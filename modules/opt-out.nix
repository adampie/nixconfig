{ inputs, ... }:
{
  flake.homeModules.optOut =
    { ... }:
    {
      imports = [
        inputs.opt-out.homeManagerModules.default
      ];
    };
}
