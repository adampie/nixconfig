{
  pkgs,
  unstablepkgs,
  ...
}: {
  home.packages =
    (with pkgs; [
      dive
      just
      kubectl
      kubernetes-helm
    ])
    ++ (with unstablepkgs; []);
}
