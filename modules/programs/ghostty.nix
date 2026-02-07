{...}: {
  flake.modules.homeManager.ghostty = {
    programs.ghostty = {
      enable = true;
      package = null;
      enableZshIntegration = true;
      settings = {
        theme = "Dracula+";
        font-family = "Hack Nerd Font Mono";
        copy-on-select = "clipboard";
        working-directory = "home";
        window-inherit-working-directory = false;
        shell-integration = "zsh";
        window-save-state = "always";
        auto-update = "off";
        keybind = [
          "shift+enter=text:\\n"
        ];
      };
    };
  };
}
