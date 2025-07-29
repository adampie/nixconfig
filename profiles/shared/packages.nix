{
  pkgs,
  unstablepkgs,
  ...
}: {
  home.packages =
    (with pkgs; [
      aider-chat
      alejandra
      awscli
      cosign
      colordiff
      curl
      diffutils
      gh
      ghorg
      git
      glab
      gnupg
      go
      jq
      nodejs_24
      python313
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
    ]);
}
