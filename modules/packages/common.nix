{ ... }:
{
  flake.homeModules.packagesCommon =
    { pkgs, lib, ... }:
    {
      home.packages =
        with pkgs;
        [
          cosign
          curl
          jq
          ripgrep
          wget
          yq
        ]
        ++ lib.optionals (!pkgs.stdenv.isDarwin) [
        ];
    };
}
