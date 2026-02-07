{...}: {
  flake.modules.homeManager.telemetry = {
    home.sessionVariables = {
      NO_TELEMETRY = "1";
      DO_NOT_TRACK = "1";
      HOMEBREW_NO_ANALYTICS = "1";
      CHECKPOINT_DISABLE = "1";
      GOTELEMETRY = "off";
      NUXT_TELEMETRY_DISABLED = "1";
      NEXT_TELEMETRY_DISABLED = "1";
      CDK_DISABLE_CLI_TELEMETRY = "true";
      CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
      GEMINI_TELEMETRY_ENABLED = "false";
    };

    home.file.".homebrew/brew.env".text = ''
      export HOMEBREW_NO_ANALYTICS=1
      export HOMEBREW_CASK_OPTS=--require-sha
      export HOMEBREW_NO_AUTO_UPDATE=1
      export HOMEBREW_NO_ENV_HINTS=1
      export HOMEBREW_NO_INSECURE_REDIRECT=1
    '';
  };
}
