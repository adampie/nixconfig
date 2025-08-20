{
  pkgs,
  unstablepkgs,
  lib,
  ...
}: {
  home.packages =
    (with pkgs; [
      # Core CLI tools
      aider-chat
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
      glab
      gnupg
      go
      jq
      # nodejs_24
      # python313
      ripgrep
      starship
      tldr
      watch
      wget
      yq
    ])
    ++ (with unstablepkgs; [
      claude-code
      codex
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
