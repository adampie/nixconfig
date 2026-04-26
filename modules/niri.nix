{ inputs, self, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages = lib.optionalAttrs pkgs.stdenv.isLinux {
        myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
          inherit pkgs;
          settings = {
            input.keyboard.xkb.layout = "gb";

            layout.gaps = 5;

            xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

            spawn-at-startup = [
              [ (lib.getExe self'.packages.myNoctalia) ]
              [ "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1" ]
              [
                (lib.getExe pkgs.swayidle)
                "-w"
                "timeout"
                "300"
                (lib.getExe pkgs.swaylock)
                "timeout"
                "600"
                "niri msg action power-off-monitors"
                "resume"
                "niri msg action power-on-monitors"
                "before-sleep"
                (lib.getExe pkgs.swaylock)
              ]
            ];

            binds = {
              # Apps
              "Mod+Return".spawn-sh = lib.getExe pkgs.ghostty;
              "Mod+Shift+Return".spawn-sh = lib.getExe pkgs.foot;
              "Mod+Space".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
              "Mod+Comma".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call settings toggle";
              "Mod+N".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call notifications toggleHistory";
              "Mod+Escape".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call sessionMenu toggle";

              # Session
              "Mod+Q".close-window = _: { };
              "Mod+Shift+E".quit = _: { };
              "Mod+Backspace".spawn-sh = lib.getExe pkgs.swaylock;

              # Focus column / row (HJKL + arrows)
              "Mod+H".focus-column-left = _: { };
              "Mod+L".focus-column-right = _: { };
              "Mod+J".focus-window-down = _: { };
              "Mod+K".focus-window-up = _: { };
              "Mod+Left".focus-column-left = _: { };
              "Mod+Right".focus-column-right = _: { };
              "Mod+Down".focus-window-down = _: { };
              "Mod+Up".focus-window-up = _: { };

              # Move column / row
              "Mod+Shift+H".move-column-left = _: { };
              "Mod+Shift+L".move-column-right = _: { };
              "Mod+Shift+J".move-window-down = _: { };
              "Mod+Shift+K".move-window-up = _: { };
              "Mod+Shift+Left".move-column-left = _: { };
              "Mod+Shift+Right".move-column-right = _: { };
              "Mod+Shift+Down".move-window-down = _: { };
              "Mod+Shift+Up".move-window-up = _: { };

              # Window state
              "Mod+R".switch-preset-column-width = _: { };
              "Mod+M".maximize-column = _: { };
              "Mod+F".fullscreen-window = _: { };
              "Mod+V".toggle-window-floating = _: { };
              "Mod+W".toggle-column-tabbed-display = _: { };

              # Workspaces
              "Mod+Page_Down".focus-workspace-down = _: { };
              "Mod+Page_Up".focus-workspace-up = _: { };
              "Mod+Shift+Page_Down".move-column-to-workspace-down = _: { };
              "Mod+Shift+Page_Up".move-column-to-workspace-up = _: { };

              "Mod+1".focus-workspace = 1;
              "Mod+2".focus-workspace = 2;
              "Mod+3".focus-workspace = 3;
              "Mod+4".focus-workspace = 4;
              "Mod+5".focus-workspace = 5;
              "Mod+6".focus-workspace = 6;
              "Mod+7".focus-workspace = 7;
              "Mod+8".focus-workspace = 8;
              "Mod+9".focus-workspace = 9;

              "Mod+Shift+1".move-column-to-workspace = 1;
              "Mod+Shift+2".move-column-to-workspace = 2;
              "Mod+Shift+3".move-column-to-workspace = 3;
              "Mod+Shift+4".move-column-to-workspace = 4;
              "Mod+Shift+5".move-column-to-workspace = 5;
              "Mod+Shift+6".move-column-to-workspace = 6;
              "Mod+Shift+7".move-column-to-workspace = 7;
              "Mod+Shift+8".move-column-to-workspace = 8;
              "Mod+Shift+9".move-column-to-workspace = 9;

              # Audio (PipeWire)
              "XF86AudioRaiseVolume".spawn-sh =
                "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 5%+";
              "XF86AudioLowerVolume".spawn-sh =
                "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 5%-";
              "XF86AudioMute".spawn-sh =
                "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle";
              "XF86AudioMicMute".spawn-sh =
                "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

              # Brightness
              "XF86MonBrightnessUp".spawn-sh = "${lib.getExe pkgs.brightnessctl} set 5%+";
              "XF86MonBrightnessDown".spawn-sh = "${lib.getExe pkgs.brightnessctl} set 5%-";

              # Screenshot
              "Print".screenshot = _: { };
            };
          };
        };
      };
    };

  flake.nixosModules.niri =
    { pkgs, ... }:
    {
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
      };

      # Noctalia required services
      services.power-profiles-daemon.enable = true;
      services.upower.enable = true;

      # Wayland session ergonomics
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
        ];
        config.niri.default = [
          "gnome"
          "gtk"
        ];
      };

      security.polkit.enable = true;
      services.gnome.gnome-keyring.enable = true;

      environment.systemPackages = with pkgs; [
        polkit_gnome
        swaylock
        swayidle
        brightnessctl
        pavucontrol
        wl-clipboard
        foot
      ];

      # GB layout at the seat level (login & TTY)
      console.keyMap = "uk";

      # Noctalia binary cache
      nix.settings = {
        extra-substituters = [ "https://noctalia.cachix.org" ];
        extra-trusted-public-keys = [
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };
    };
}
