{ ... }:
{
  flake.homeModules.packagesCommon =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        cosign
        curl
        package-version-server
        pciutils
        tree
        wget
        yq
      ];
    };
}
