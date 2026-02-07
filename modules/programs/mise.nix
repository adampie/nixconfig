{...}: {
  flake.modules.homeManager.mise = {
    programs.mise = {
      enable = true;
      enableZshIntegration = true;
      globalConfig = {
        settings.experimental = true;
        tools = {
          nodejs = "lts";
          python = "latest";
          go = "latest";
        };
      };
    };
  };
}
