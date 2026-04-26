{ ... }:
let
  # nixpkgs' mise hardcodes a direnv store path into its source via
  # postPatch, dragging direnv into the closure even when we don't use it
  # (mise upstream actively discourages combining mise with direnv). Swap
  # direnv for a stub so the real direnv is never built and `mise direnv
  # exec` fails loudly if anyone invokes it.
  miseOverlay =
    { ... }:
    {
      nixpkgs.overlays = [
        (_: prev: {
          mise = prev.mise.override {
            direnv = prev.writeShellScriptBin "direnv" ''
              echo "direnv is intentionally disabled in this nix config" >&2
              exit 1
            '';
          };
        })
      ];
    };
in
{
  flake.homeModules.mise =
    { ... }:
    {
      programs.mise = {
        enable = true;
        enableZshIntegration = true;
        globalConfig = {
          settings.experimental = true;
          tools = {
            go = "latest";
            hk = "latest";
            nodejs = "lts";
            pkl = "latest";
            python = "latest";
          };
        };
      };
    };

  flake.darwinModules.mise = miseOverlay;
  flake.nixosModules.mise = miseOverlay;
}
