{
  pkgs,
  unstablepkgs,
  ...
}: {
  home.packages =
    (with pkgs; [
      aws-vault
      dive
      gettext
      just
      kubectl
      kubernetes-helm
    ])
    ++ (with unstablepkgs; []);
}
