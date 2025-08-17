_: {
  programs.git = {
    extraConfig = {
      commit = {gpgsign = true;};
      gpg = {format = "ssh";};
      "gpg.ssh" = {program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";};
    };
    includes = [
      {
        condition = "gitdir:~/Code/zapier/";
        contents = {user.email = "adam.pietrzycki@zapier.com";};
      }
    ];
    signing = {
      signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEryumdeAtrZMZwW8DUPC6l4fhhS2B6ovLeX5QNynTTY";
      signByDefault = true;
    };
    userEmail = "adam.pietrzycki@zapier.com";
  };
}
