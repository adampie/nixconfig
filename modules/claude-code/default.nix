{ ... }:
{
  flake.homeModules.claudeCode =
    { pkgs, ... }:
    {
      programs.claude-code = {
        enable = true;
        package = if pkgs.stdenv.isDarwin then null else pkgs.claude-code;
        skills = ./skills;
        rulesDir = ./rules;
        settings = {
          effortLevel = "high";
          model = "claude-opus-4-6[1m]";
          env = {
            DISABLE_AUTOUPDATER = "1";
            DISABLE_ERROR_REPORTING = "1";
            DISABLE_TELEMETRY = "1";
            DISABLE_FEEDBACK_COMMAND = "1";
            CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = "1";
          };
          attribution = {
            commit = "";
            pr = "";
          };
          permissions = {
            defaultMode = "acceptEdits";
          };
        };
      };
    };
}
