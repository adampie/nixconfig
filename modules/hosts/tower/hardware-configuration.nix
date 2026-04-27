{ ... }:
{
  flake.nixosModules.towerHardware =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      # Boot
      boot.loader.systemd-boot.enable = true;
      boot.loader.systemd-boot.configurationLimit = 3;
      boot.loader.efi.canTouchEfiVariables = true;

      # Quiet boot: silence ACPI BIOS spam over the LUKS prompt and
      # systemd unit status messages over the login screen.
      boot.kernelParams = [
        "quiet"
        "loglevel=3"
        "udev.log_level=3"
        "rd.udev.log_level=3"
        "systemd.show_status=false"
        "rd.systemd.show_status=false"
        "vt.global_cursor_default=0"
        "nvidia-drm.fbdev=1"
      ];
      boot.consoleLogLevel = 0;
      boot.initrd.verbose = false;

      # Plymouth provides a graphical LUKS password prompt rather than
      # text over which the kernel can scribble. Requires systemd in initrd.
      boot.plymouth.enable = true;
      boot.initrd.systemd.enable = true;

      boot.initrd.availableKernelModules = [
        "vmd"
        "xhci_pci"
        "ahci"
        "nvme"
        "thunderbolt"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      boot.kernelModules = [ "kvm-intel" ];

      # NVIDIA
      boot.initrd.kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];

      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          intel-media-driver
          nvidia-vaapi-driver
        ];
      };

      hardware.nvidia = {
        modesetting.enable = true;
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        powerManagement.enable = true;
      };

      systemd.tmpfiles.rules = [
        "d /var/tmp/nvidia 0700 root root -"
      ];
      environment.variables = {
        NVIDIA_SLEEP_VRAM_SAVE_PATH = "/var/tmp/nvidia";
        LIBVA_DRIVER_NAME = "nvidia";
      };

      # Bluetooth
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;

      # CPU
      services.thermald.enable = true;
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      hardware.enableRedistributableFirmware = true;

      nixpkgs.hostPlatform = "x86_64-linux";
    };
}
