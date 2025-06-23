{
  pkgs,
  unstablepkgs,
  ...
}: {
  home.packages =
    (with pkgs; [
      ghidra
      goreleaser
      neofetch
      fh
      wireshark
    ])
    ++ (with unstablepkgs; []);
}
