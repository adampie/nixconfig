{ ... }:
{
  flake.homeModules.ghostty =
    { pkgs, ... }:
    {
      programs.ghostty = {
        enable = true;
        package = if pkgs.stdenv.isDarwin then null else pkgs.ghostty;
        enableZshIntegration = true;
        settings = {
          auto-update = "off";
          copy-on-select = "clipboard";
          font-family = "Hack Nerd Font Mono";
          keybind = [
            "shift+enter=text:\\n"
          ];
          scrollback-limit = 100000000;
          shell-integration = "zsh";
          theme = "Dracula+";
          window-inherit-working-directory = false;
          window-save-state = "always";
          working-directory = "home";
        };
      };
    };
}
