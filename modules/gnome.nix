{ ... }:
{
  flake.nixosModules.gnome =
    { pkgs, ... }:
    {
      services.xserver.enable = true;
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
      environment.systemPackages = with pkgs; [
        gnomeExtensions.tiling-assistant
      ];
    };
}
