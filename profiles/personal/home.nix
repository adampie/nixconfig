{
  config,
  pkgs,
  unstablepkgs,
  lib,
  ...
}: {
  imports = [
    ../shared/packages.nix
  ];

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    neofetch
    fh
  ];

  programs.git = {
    extraConfig = {
      commit = {gpgsign = true;};
      gpg = {format = "ssh";};
      "gpg.ssh" = {program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";};
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
    userEmail = "adam@pietrzycki.com";
  };
}
