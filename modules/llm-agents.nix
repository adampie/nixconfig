{ inputs, ... }:
let
  overlayModule =
    { ... }:
    {
      nixpkgs.overlays = [ inputs.llm-agents.overlays.shared-nixpkgs ];
    };
  cacheModule =
    { ... }:
    {
      nix.settings = {
        extra-substituters = [ "https://cache.numtide.com" ];
        extra-trusted-public-keys = [
          "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        ];
      };
    };
in
{
  flake.darwinModules.llmAgents =
    { ... }:
    {
      imports = [
        overlayModule
        cacheModule
      ];
    };

  flake.nixosModules.llmAgents =
    { ... }:
    {
      imports = [
        overlayModule
        cacheModule
      ];
    };
}
