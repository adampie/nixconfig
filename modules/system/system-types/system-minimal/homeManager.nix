{...}: {
  flake.modules.homeManager.system-minimal = {
    home.stateVersion = "25.11";

    home.file.".hushlogin".text = "";
  };
}
