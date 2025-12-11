{
  pkgs,
  unstablepkgs,
  lib,
  ...
}: {
  home.packages =
    (with pkgs; [
      alejandra
      awscli2
      cosign
      colordiff
      curl
      devenv
      diffutils
      gh
      ghorg
      git
      gnupg
      jq
      ripgrep
      starship
      tldr
      watch
      wget
      yq
    ])
    ++ (with unstablepkgs; [
      mise
      nerd-fonts.jetbrains-mono
    ])
    ++ lib.optionals pkgs.stdenv.isDarwin [
      # Darwin-specific packages
      pkgs.mas
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      # Linux-specific packages would go here
      # pkgs.xclip
      # pkgs.wl-clipboard
    ];
}
