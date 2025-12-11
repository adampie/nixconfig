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
      glab
      just
      kubectl
      kubernetes-helm
    ])
    ++ (with unstablepkgs; []);
}
