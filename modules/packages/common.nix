{ ... }:
{
  flake.homeModules.packagesCommon =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        cosign
        curl
        fastfetch
        package-version-server
        pciutils
        tree
        wget
        yq
      ];
    };
}
