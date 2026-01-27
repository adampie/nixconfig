# Home Manager backup configuration
{...}: {
  flake.modules.darwin.home-manager-config = {
    home-manager = {
      overwriteBackup = true;
      backupFileExtension = "backup";
    };
  };
}
