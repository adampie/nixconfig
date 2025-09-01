{
  pkgs,
  unstablepkgs,
  ...
}: {
  home.packages =
    (with pkgs; [
      fh
      goreleaser
      neofetch
    ])
    ++ (with unstablepkgs; []);
}
