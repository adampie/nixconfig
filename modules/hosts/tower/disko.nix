{ inputs, ... }:
{
  flake.nixosModules.towerDisko =
    { ... }:
    {
      imports = [
        inputs.disko.nixosModules.disko
      ];

      disko.devices.disk.main = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            root = {
              label = "root";
              size = "100%";
              priority = 3;
              content = {
                type = "luks";
                name = "cryptroot";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                };
              };
            };
            swap = {
              label = "swap";
              size = "16G";
              priority = 2;
              content = {
                type = "luks";
                name = "cryptswap";
                content = {
                  type = "swap";
                };
              };
            };
            ESP = {
              label = "ESP";
              size = "4G";
              type = "EF00";
              priority = 1;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "fmask=0077"
                  "dmask=0077"
                ];
              };
            };
          };
        };
      };
    };
}
