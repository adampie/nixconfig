{ inputs, ... }:
{
  flake.homeModules.noctalia =
    { pkgs, ... }:
    {
      imports = [ inputs.noctalia.homeModules.default ];

      programs.noctalia-shell = {
        enable = true;
        package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
        settings = builtins.fromJSON (builtins.readFile ./noctalia.json);
      };
    };
}
