{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/system/wsl.nix
  ];

  host = {
    username = "adampie";
    hostname = "AdamPC";
    homeProfile = ../../profiles/shared/default.nix;
  };
}
