{...}: {
  flake.modules.homeManager.user = {
    pkgs,
    lib,
    ...
  }: {
    home = {
      username = "adampie";
      homeDirectory = "/Users/adampie";
      stateVersion = "25.11";

      activation = {
        createDirectories = lib.hm.dag.entryAfter ["writeBoundary"] ''
          $DRY_RUN_CMD mkdir -p $HOME/Code
          $DRY_RUN_CMD mkdir -p $HOME/Screenshots
        '';
      };

      sessionVariables = {
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

      sessionPath = [
        "$HOME/.local/bin"
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
      ];

      packages = with pkgs; [
        cosign
        curl
        devenv
        fh
        jq
        nerd-fonts.hack
        nil
        nixd
        ripgrep
        wget
        yq
      ];

      file = {
        ".homebrew/brew.env".text = ''
          export HOMEBREW_NO_ANALYTICS=1
          export HOMEBREW_CASK_OPTS=--require-sha
          export HOMEBREW_NO_AUTO_UPDATE=1
          export HOMEBREW_NO_ENV_HINTS=1
          export HOMEBREW_NO_INSECURE_REDIRECT=1
        '';

        ".hushlogin".text = "";
        ".local/bin/.keep".text = "";
      };
    };

    programs.gpg.enable = true;
  };
}
