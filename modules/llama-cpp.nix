{ ... }:
{
  flake.nixosModules.llamaCpp =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        (pkgs.llama-cpp.override { cudaSupport = true; })
      ];
    };
}
