{ self, inputs, ... }:
{
  flake.nixosConfigurations.tower = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.hostTower ];
  };

  flake.nixosModules.hostTower =
    { config, lib, pkgs, ... }:
    let
      username = "adampie";
      homeDirectory = "/home/${username}";
    in
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        self.nixosModules.towerDisko
        self.nixosModules.towerHardware
      ];

      nixpkgs.config.allowUnfree = true;
      system.stateVersion = "25.11";

      # Boot
      boot.loader.systemd-boot.enable = true;
      boot.loader.systemd-boot.configurationLimit = 3;
      boot.loader.efi.canTouchEfiVariables = true;

      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;

      # NVIDIA
      boot.initrd.kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];

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
      environment.variables.NVIDIA_SLEEP_VRAM_SAVE_PATH = "/var/tmp/nvidia";

      # Nix
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix.settings.auto-optimise-store = true;
      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      # Network
      networking.hostName = "tower";
      networking.networkmanager.enable = true;

      # Locale
      time.timeZone = "Europe/London";
      i18n.defaultLocale = "en_GB.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_GB.UTF-8";
        LC_IDENTIFICATION = "en_GB.UTF-8";
        LC_MEASUREMENT = "en_GB.UTF-8";
        LC_MONETARY = "en_GB.UTF-8";
        LC_NAME = "en_GB.UTF-8";
        LC_NUMERIC = "en_GB.UTF-8";
        LC_PAPER = "en_GB.UTF-8";
        LC_TELEPHONE = "en_GB.UTF-8";
        LC_TIME = "en_GB.UTF-8";
      };
      console.keyMap = "uk";

      # Fonts
      fonts = {
        fontDir.enable = true;
        packages = with pkgs; [
          nerd-fonts.hack
        ];
        fontconfig.defaultFonts.monospace = [ "Hack Nerd Font" ];
      };

      # Desktop
      services.xserver.enable = true;
      services.xserver.videoDrivers = [ "nvidia" ];
      services.xserver.xkb.layout = "gb";
      services.displayManager.gdm.enable = true;
      services.displayManager.gdm.wayland = true;
      services.desktopManager.gnome.enable = true;
      services.gnome.games.enable = false;
      documentation.nixos.enable = false;
      environment.gnome.excludePackages = with pkgs; [
        baobab
        decibels
        epiphany
        gnome-calendar
        gnome-characters
        gnome-connections
        gnome-contacts
        gnome-maps
        gnome-music
        gnome-text-editor
        gnome-tour
        gnome-user-docs
        gnome-weather
        showtime
        snapshot
        yelp
      ];
      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      # Audio
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      # Printing
      services.printing.enable = true;
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      # Services
      services.locate = {
        enable = true;
        package = pkgs.plocate;
      };
      services.journald.extraConfig = ''
        SystemMaxUse=500M
        MaxRetentionSec=1month
      '';
      services.thermald.enable = true;
      services.fwupd.enable = true;
      services.hardware.bolt.enable = true;

      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
          AllowUsers = [ "adampie" ];
          MaxAuthTries = 3;
          X11Forwarding = false;
          AllowTcpForwarding = false;
          AllowAgentForwarding = false;
          Ciphers = [
            "chacha20-poly1305@openssh.com"
            "aes256-gcm@openssh.com"
          ];
        };
        hostKeys = [
          {
            path = "/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
        ];
      };

      services.mullvad-vpn = {
        enable = true;
        package = pkgs.mullvad-vpn;
      };

      # Programs
      users.defaultUserShell = pkgs.zsh;
      programs.zsh.enable = true;
      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = with pkgs; [ stdenv.cc.cc.lib ];
      programs.firefox.enable = true;
      programs.steam.enable = true;
      programs._1password.enable = true;
      programs._1password-gui.enable = true;

      # Containers
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      # System packages
      environment.systemPackages = with pkgs; [
        btop
        curl
        ghostty
        git
        gnomeExtensions.tiling-assistant
        pciutils
        vim
        wget
        nextdns
      ];

      # User
      users.users.${username} = {
        isNormalUser = true;
        home = homeDirectory;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIYZ1p3R75b204KSQl4887UafxsK+ybuEbSZPd58ZaJ1"
        ];
        packages = with pkgs; [
          discord
          tree
          spotify
          slack
        ];
      };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${username} = {
          imports = [
            self.homeModules.claudeCode
            self.homeModules.ghostty
            self.homeModules.git
            self.homeModules.gpg
            self.homeModules.mise
            self.homeModules.optOut
            self.homeModules.starship
            self.homeModules.zed
            self.homeModules.zsh
          ];
          home = {
            inherit username homeDirectory;
            stateVersion = "25.11";
            packages = with pkgs; [
              gh
              jq
              neovim
              nil
              nixd
              package-version-server
              ripgrep
              vlc
              yq
            ];
          };
        };
      };
    };
}
