{
  pkgs,
  unstablepkgs,
  ...
}: {
  home.packages =
    (with pkgs; [
      alejandra
      awscli
      cosign
      curl
      gh
      ghorg
      git
      gnupg
      jq
      mise
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
      nerd-fonts.jetbrains-mono
    ]);
}
