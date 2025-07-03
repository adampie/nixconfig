{
  pkgs,
  unstablepkgs,
  ...
}: {
  home.packages =
    (with pkgs; [
      fh
      ghidra
      goreleaser
      neofetch
      wireshark
    ])
    ++ (with unstablepkgs; []);
}
