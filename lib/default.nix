{lib, ...}: let
  scripts = import ./scripts.nix {};
  systems = import ./systems.nix {
    inherit lib;
    inherit (scripts) mkJetBrainsDarwinScript;
  };
in
  scripts // systems
