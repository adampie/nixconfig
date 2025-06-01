{
  pkgs,
  unstablepkgs,
  ...
}: {
  home.packages =
    (with pkgs; [
      dive
      glab
      just
      kubectl
      kubernetes-helm
    ])
    ++ (with unstablepkgs; []);
}
