{config, ...}: let
  dm = config.flake.modules.darwin;
  hm = config.flake.modules.homeManager;
in {
  flake.modules.darwin.system-cli = {
    imports = [
      dm.system-default
      dm.homebrew
      dm.macos-defaults
      dm.dock
      dm.finder
      dm.security
      dm.desktop
      dm.privacy
    ];
  };

  flake.modules.homeManager.system-cli = {
    imports = [
      hm.system-default
      hm.cli-tools
      hm.fonts
      hm.git
      hm.mise
      hm.zsh
      hm.starship
      hm.gpg
      hm.ssh
      hm.telemetry
    ];
  };
}
