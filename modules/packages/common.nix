{ ... }:
{
  flake.homeModules.packagesCommon =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        cosign
        curl
        jq
        ripgrep
        wget
        yq
      ];
    };
}
