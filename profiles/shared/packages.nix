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
      curl
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
      claude-code
      codex
      mise
      nerd-fonts.jetbrains-mono
    ]);
}
