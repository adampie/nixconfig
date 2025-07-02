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
      rustup
      wireshark
    ])
    ++ (with unstablepkgs; []);
}
