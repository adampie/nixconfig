{...}: {
  imports = [./default.nix];

  home = {
    file.".local/bin/fac" = {
      text = ''
        #!/usr/bin/env zsh
        fetch_all_code "github" "user" "adampie"
        fetch_all_code "github" "org" "fricory"
      '';
      executable = true;
    };
  };

  programs = {
    git = {
      settings = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        "gpg.ssh".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        user.email = "adam@pietrzycki.com";
      };
      includes = [
        {
          condition = "gitdir:~/Code/fricory/";
          contents = {user.email = "adam@fricory.com";};
        }
      ];
      signing = {
        signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBpWz+23cfr/f+6dYL/19Ce1uTKiQ3Vy3yJy4avkENSc";
        signByDefault = true;
      };
    };

    zed-editor.userSettings = {
      features = {
        edit_prediction_provider = "none";
      };
    };
  };
}
