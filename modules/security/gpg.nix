# GPG configuration
{...}: {
  flake.modules.homeManager.gpg = {
    programs.gpg.enable = true;
  };
}
