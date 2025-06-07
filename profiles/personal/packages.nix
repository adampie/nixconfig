{
  pkgs,
  unstablepkgs,
  ...
}: {
  home.packages =
    (with pkgs; [
      goreleaser
      neofetch
      fh
    ])
    ++ (with unstablepkgs; []);
}
