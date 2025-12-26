{...}: {
  imports = [./default.nix];

  home.file.".local/bin/fac" = {
    text = ''
      #!/usr/bin/env zsh
      fetch_all_code "gitlab" "org" "zapier"
    '';
    executable = true;
  };

  programs = {
    git = {
      settings = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        "gpg.ssh".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        user.email = "adam.pietrzycki@zapier.com";
      };
      includes = [
        {
          condition = "gitdir:~/Code/zapier/";
          contents = {
            user.email = "adam.pietrzycki@zapier.com";
          };
        }
      ];
      signing = {
        signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEryumdeAtrZMZwW8DUPC6l4fhhS2B6ovLeX5QNynTTY";
        signByDefault = true;
      };
    };

    mise.globalConfig.tools = {
      terraform = "latest";
      nodejs = "lts";
      go = "latest";
    };

    zed-editor.userSettings = {
      features = {
        edit_prediction_provider = "none";
      };
    };
  };
}
