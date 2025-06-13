{
  pkgs,
  unstablepkgs,
  ...
}: {
  home.packages =
    (with pkgs; [
      devenv
      goreleaser
      neofetch
      fh
    ])
    ++ (with unstablepkgs; []);
}
