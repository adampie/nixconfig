# Disable telemetry across various tools
{...}: {
  flake.modules.homeManager.disable-telemetry = {
    home.sessionVariables = {
      NO_TELEMETRY = "1";
      DO_NOT_TRACK = "1";
      HOMEBREW_NO_ANALYTICS = "1";
      CHECKPOINT_DISABLE = "1"; # HashiCorp
      GOTELEMETRY = "off";
      NUXT_TELEMETRY_DISABLED = "1";
      NEXT_TELEMETRY_DISABLED = "1";
      CDK_DISABLE_CLI_TELEMETRY = "true";
      CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
      GEMINI_TELEMETRY_ENABLED = "false";
    };
  };
}
