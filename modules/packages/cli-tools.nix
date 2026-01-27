# Essential CLI tools
{...}: {
  flake.modules.homeManager.cli-tools = {pkgs, ...}: {
    home.packages = with pkgs; [
      cosign
      curl
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
