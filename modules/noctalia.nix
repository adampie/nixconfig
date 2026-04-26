{ inputs, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    {
      packages = lib.optionalAttrs pkgs.stdenv.isLinux {
        myNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
          inherit pkgs;
          settings = builtins.fromJSON (builtins.readFile ./noctalia.json);
        };
      };
    };

  flake.homeModules.noctalia =
    { ... }:
    {
      imports = [ inputs.noctalia.homeModules.default ];

      programs.noctalia-shell = {
        enable = true;
        settings = builtins.fromJSON (builtins.readFile ./noctalia.json);
      };
    };
}
