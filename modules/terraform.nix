{ ... }:
{
  flake.homeModules.terraform =
    { lib, ... }:
    {
      home.sessionVariables = {
        TF_PLUGIN_CACHE_DIR = "$HOME/.terraform.d/plugin-cache";
      };
      home.activation.createTerraformCacheDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD mkdir -p $HOME/.terraform.d/plugin-cache
      '';
    };
}
