{...}: {
  home.stateVersion = "25.05";

  home.file.".config/ghostty/config".text = ''
    theme = Dracula+
    shell-integration = zsh
    copy-on-select = clipboard
    window-save-state = always
    font-family = "JetBrainsMono Nerd Font"
    working-directory = home
  '';

  home.file.".config/starship.toml".text = ''
    "$schema" = 'https://starship.rs/config-schema.json'

    add_newline = true

    [character]
    success_symbol = '[➜](bold green)'

    [cmd_duration]
    format = '[ $duration]($style)'

    [package]
    disabled = true
  '';

  home.file.".homebrew/brew.env".text = ''
    export HOMEBREW_NO_ANALYTICS=1
    export HOMEBREW_CASK_OPTS=--require-sha
    export HOMEBREW_NO_AUTO_UPDATE=1
    export HOMEBREW_NO_ENV_HINTS=1
    export HOMEBREW_NO_INSECURE_REDIRECT=1
  '';

  home.file.".hushlogin".text = "";

  home.file.".ssh/config".text = ''
    Include ~/.orbstack/ssh/config

    Host *
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  '';

  home.file."Code/.keep".text = "";
  home.file."Screenshots/.keep".text = "";

  home.sessionVariables = {
    NO_TELEMETRY = "1";
    DO_NOT_TRACK = "1";
  };

  home.file.".local/bin/.keep".text = "";
  home.file.".local/bin/idea" = {
    text = ''
      #!/bin/sh
      open -na "IntelliJ IDEA.app" --args "$@"
    '';
    executable = true;
  };
  home.file.".local/bin/pycharm" = {
    text = ''
      #!/bin/sh
      open -na "PyCharm.app" --args "$@"
    '';
    executable = true;
  };
  home.file.".local/bin/goland" = {
    text = ''
      #!/bin/sh
      open -na "GoLand.app" --args "$@"
    '';
    executable = true;
  };
  home.file.".local/bin/datagrip" = {
    text = ''
      #!/bin/sh
      open -na "DataGrip.app" --args "$@"
    '';
    executable = true;
  };

  home.file.".local/bin/nixus" = {
    text = ''
      #!/usr/bin/env zsh
      set -e
      nix flake update && \
      darwin-rebuild build --flake .# && \
      diff_output=$(nix store diff-closures /run/current-system ./result)
      if [[ -z "$diff_output" || "$diff_output" == *"no changes"* ]]; then
        echo "No changes detected. Cleaning up."
        rm -rf ./result
        exit 0
      else
        echo "$diff_output"
        echo -n "Continue with switch? (y/n): "
        read ans
        if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
          darwin-rebuild switch --flake .#
        fi
        rm -rf ./result
      fi
    '';
    executable = true;
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
