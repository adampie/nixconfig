# Git configuration with 1Password signing
{...}:
let
  defaultEmail = "adam@pietrzycki.com";
  defaultName = "Adam Pietrzycki";
  fricoryEmail = "adam@fricory.com";
  signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBpWz+23cfr/f+6dYL/19Ce1uTKiQ3Vy3yJy4avkENSc";
  opSshSign = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
in {
  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      settings = {
        init.defaultBranch = "main";
        user.name = defaultName;
        user.email = defaultEmail;
        commit.gpgsign = true;
        gpg.format = "ssh";
        "gpg.ssh".program = opSshSign;
      };

      includes = [
        {
          condition = "gitdir:~/Code/fricory/";
          contents.user.email = fricoryEmail;
        }
      ];

      signing = {
        signer = opSshSign;
        key = signingKey;
        signByDefault = true;
      };
    };
  };
}
