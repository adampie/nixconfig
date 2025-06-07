{config, pkgs, unstablepkgs, ...}: {
  programs = {
    git = {
      enable = true;
      extraConfig = {init = {defaultBranch = "main";};};
      userName = "Adam Pietrzycki";
    };

    gpg = {
      enable = true;
    };

    mise = {
      enable = true;
      enableZshIntegration = true;
      package = unstablepkgs.mise;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        "$schema" = "https://starship.rs/config-schema.json";
        add_newline = true;

        character = {
          success_symbol = "[➜](bold green)";
        };

        cmd_duration = {
          format = "[ $duration]($style)";
        };

        package = {
          disabled = true;
        };
      };
    };

    zsh = {
      autosuggestion.enable = true;
      enable = true;
      enableCompletion = true;
      history = {
        save = 1000000;
        size = 1000000;
      };
      historySubstringSearch.enable = true;
      syntaxHighlighting.enable = true;
    };
  };

  home.file.".config/ghostty/config".text = ''
    theme = Dracula+
    shell-integration = zsh
    copy-on-select = clipboard
    window-save-state = always
    font-family = "JetBrainsMono Nerd Font"
    working-directory = home
    keybind = shift+enter=text:\n
  '';

  home.file.".ssh/config".text = ''
    Include ~/.orbstack/ssh/config

    Host *
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  '';
}
