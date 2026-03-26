{ ... }:
{
  flake.homeModules.packagesCommon =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        btop
        cosign
        curl
        jq
        package-version-server
        pciutils
        ripgrep
        tree
        vim
        wget
        yq
      ];
    };
}
