{ ... }:
{
  flake.homeModules.git =
    { pkgs, ... }:
    let
      op-ssh-sign =
        if pkgs.stdenv.isDarwin then
          "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
        else
          "${pkgs._1password-gui}/share/1password/op-ssh-sign";
    in
    {
      programs.git = {
        enable = true;
        settings = {
          init.defaultBranch = "main";
          user.name = "Adam Pietrzycki";
          user.email = "adam@pietrzycki.com";
          commit.gpgsign = true;
          gpg.format = "ssh";
          "gpg.ssh".program = op-ssh-sign;
        };
        signing = {
          signer = op-ssh-sign;
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBpWz+23cfr/f+6dYL/19Ce1uTKiQ3Vy3yJy4avkENSc";
          signByDefault = true;
        };
      };
    };
}
