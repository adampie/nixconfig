{ ... }: {
  flake.homeModules.claudeCode = { pkgs, ... }: {
    programs.claude-code = {
      enable = true;
      package = if pkgs.stdenv.isDarwin then null else pkgs.claude-code;
      settings = {
        theme = "dark";
        env = {
          DISABLE_AUTOUPDATER = "1";
          DISABLE_BUG_COMMAND = "1";
          DISABLE_ERROR_REPORTING = "1";
          DISABLE_TELEMETRY = "1";
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
