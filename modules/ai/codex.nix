{ ... }:
{
  flake.homeModules.codex =
    { pkgs, lib, ... }:
    {
      programs.codex = {
        enable = true;
        package = if pkgs.stdenv.isDarwin then null else pkgs.llm-agents.codex;
        context = lib.concatMapStringsSep "\n" builtins.readFile [
          ./rules/grill-plans.md
          ./rules/terraform.md
          ./rules/writing-style.md
        ];
        settings = {
          model_reasoning_effort = "high";
        };
      };
    };
}
