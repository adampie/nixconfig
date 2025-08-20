{
  pkgs,
  unstablepkgs,
  ...
}: {
  home.packages =
    (with pkgs; [
      aws-vault
      dive
      just
      kubectl
      kubernetes-helm
    ])
    ++ (with unstablepkgs; []);
}
