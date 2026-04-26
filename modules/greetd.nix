{ ... }:
{
  flake.nixosModules.greetd =
    { pkgs, ... }:
    {
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd niri-session";
            user = "greeter";
          };
        };
      };
    };
}
