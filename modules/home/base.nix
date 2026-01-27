# Home Manager base configuration
{...}:
let
  username = "adampie";
  homeDirectory = "/Users/${username}";
in {
  flake.modules.homeManager.home-base = {lib, ...}: {
    home = {
      inherit username homeDirectory;
      stateVersion = "25.11";

      activation = {
        createDirectories = lib.hm.dag.entryAfter ["writeBoundary"] ''
          $DRY_RUN_CMD mkdir -p $HOME/Code
          $DRY_RUN_CMD mkdir -p $HOME/Screenshots
        '';
      };

      sessionPath = [
        "$HOME/.local/bin"
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
      ];

      file = {
        ".hushlogin".text = "";
        ".local/bin/.keep".text = "";
      };
    };
  };
}
