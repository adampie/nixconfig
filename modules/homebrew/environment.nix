# Homebrew environment configuration
{...}: {
  flake.modules.homeManager.homebrew-environment = {
    home.file.".homebrew/brew.env".text = ''
      export HOMEBREW_NO_ANALYTICS=1
      export HOMEBREW_CASK_OPTS=--require-sha
      export HOMEBREW_NO_AUTO_UPDATE=1
      export HOMEBREW_NO_ENV_HINTS=1
      export HOMEBREW_NO_INSECURE_REDIRECT=1
    '';
  };
}
