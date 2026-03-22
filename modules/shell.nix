{ ... }:
{
  flake.homeModules.shell =
    { pkgs, ... }:
    {
      home.file.".hushlogin".text = "";
      home.sessionPath = [
        "$HOME/.local/bin"
      ]
      ++ (
        if pkgs.stdenv.isDarwin then
          [
            "/opt/homebrew/bin"
            "/opt/homebrew/sbin"
          ]
        else
          [
          ]
      );
    };
}
