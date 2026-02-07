{...}: {
  flake.modules.homeManager.cli-tools = {pkgs, ...}: {
    home.packages = with pkgs; [
      cosign
      curl
      devenv
      fh
      jq
      nil
      nixd
      ripgrep
      wget
      yq
    ];
  };
}
