{ ... }:
{
  flake.homeModules.claudeCode =
    { pkgs, ... }:
    {
      programs.claude-code = {
        enable = true;
        package = if pkgs.stdenv.isDarwin then null else pkgs.llm-agents.claude-code;
        rulesDir = ./rules;
        settings = {
          effortLevel = "xhigh";
          model = "opus[1m]";
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
            defaultMode = "auto";
          };
          enabledPlugins = {
            "grill-me@adampie" = true;
            "agent-browser@agent-browser" = true;
            "frontend-design@claude-plugins-official" = true;
            "skill-creator@claude-plugins-official" = true;
          };
          extraKnownMarketplaces = {
            adampie = {
              source = {
                source = "github";
                repo = "adampie/ai";
              };
            };
            adampie-private = {
              source = {
                source = "github";
                repo = "adampie/ai-private";
              };
            };
            agent-browser = {
              source = {
                source = "github";
                repo = "vercel-labs/agent-browser";
              };
            };
          };
        };
      };
    };
}
