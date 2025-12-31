{...}: {
  imports = [./default.nix];

  home.file.".local/bin/fac" = {
    text = ''
      #!/usr/bin/env zsh
      fetch_all_code "github" "org" "👍🏻"
    '';
    executable = true;
  };

  programs = {
    git = {
      settings = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        "gpg.ssh".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        user.email = "👍🏻";
      };
      includes = [
        {
          condition = "gitdir:~/Code/👍🏻/";
          contents = {
            user.email = "👍🏻";
          };
        }
      ];
      signing = {
        signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        key = "👍🏻";
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
