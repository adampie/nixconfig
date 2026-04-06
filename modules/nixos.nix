{ ... }:
{
  flake.nixosModules.defaults =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;

      # Nix
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix.settings.substituters = [
        "https://cache.adampie.dev"
        "https://cache.nixos.org"
      ];
      nix.settings.trusted-public-keys = [
        "cache.adampie.dev-1:bYRS3Q1Jq7IaqK5wfN6Tw4Qeo51d1kV3YaPvpfEx+ek="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      nix.settings.auto-optimise-store = true;
      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

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

      # Audio
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
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
      services.fwupd.enable = true;
      services.hardware.bolt.enable = true;

      # Programs
      users.defaultUserShell = pkgs.zsh;
      programs.zsh.enable = true;
      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = with pkgs; [ stdenv.cc.cc.lib ];
      environment.systemPackages = with pkgs; [
        git
      ];

      programs.firefox.enable = true;
      programs.steam.enable = true;
      programs._1password.enable = true;
      programs._1password-gui.enable = true;
    };
}
