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
        aliases = {
          default = "!git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'";
          gone = "!git fetch -p && git branch --format '%(if:equals=gone)%(upstream:track,nobracket)%(then)%(refname:short)%(end)' --omit-empty | xargs -r git branch -D";
          pr = "!gh pr view --web";
          aliases = "!git config --get-regexp ^alias\\. | sed 's/alias\\.//'";
          s = "status -sb";
          lg = "log --graph --pretty=format:'%C(auto)%h %d %s %C(dim)(%cr) <%an>' --abbrev-commit";
          sw = "switch";
          tidy = "!git gone && git remote prune origin";
          cm = "commit -m";
          d = "diff";
          dc = "diff --cached";
        };
        signing = {
          signer = op-ssh-sign;
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBpWz+23cfr/f+6dYL/19Ce1uTKiQ3Vy3yJy4avkENSc";
          signByDefault = true;
        };
      };
    };
}
