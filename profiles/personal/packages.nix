{
  pkgs,
  unstablepkgs,
  ...
}: {
  home.packages =
    (with pkgs; [
      neofetch
      fh
    ])
    ++ (with unstablepkgs; []);
}
