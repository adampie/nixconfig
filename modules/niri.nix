{ inputs, self, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      system,
      ...
    }:
    let
      noctaliaBin = lib.getExe inputs.noctalia.packages.${system}.default;
    in
    {
      packages = lib.optionalAttrs pkgs.stdenv.isLinux {
        myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
          inherit pkgs;
          settings = {
            input.keyboard.xkb.layout = "gb";

            layout.gaps = 5;

            xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

            outputs."DP-1" = {
              mode = "5120x1440@59.977";
              scale = 1.0;
            };

            spawn-at-startup = [
              [ noctaliaBin ]
              [ "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent" ]
            ];

            binds = {
              # Apps
              "Mod+T".spawn-sh = lib.getExe pkgs.ghostty;
              "Mod+Space".spawn-sh = "${noctaliaBin} ipc call launcher toggle";
              "Mod+Shift+Escape".spawn-sh = "${noctaliaBin} ipc call sessionMenu toggle";

              # Session
              "Mod+Q" = _: {
                props = {
                  repeat = false;
                };
                content = {
                  close-window = _: { };
                };
              };
              "Mod+Alt+L" = _: {
                props = {
                  allow-inhibiting = false;
                };
                content = {
                  spawn-sh = "${noctaliaBin} ipc call lockScreen lock";
                };
              };
              "Mod+Escape" = _: {
                props = {
                  allow-inhibiting = false;
                };
                content = {
                  toggle-keyboard-shortcuts-inhibit = _: { };
                };
              };

              # Column composition
              "Mod+Comma".consume-window-into-column = _: { };
              "Mod+Period".expel-window-from-column = _: { };
              "Mod+BracketLeft".consume-or-expel-window-left = _: { };
              "Mod+BracketRight".consume-or-expel-window-right = _: { };

              # Focus column / row
              "Mod+Left".focus-column-left = _: { };
              "Mod+Right".focus-column-right = _: { };
              "Mod+Down".focus-window-down = _: { };
              "Mod+Up".focus-window-up = _: { };

              # Focus monitor
              "Mod+Shift+Left".focus-monitor-left = _: { };
              "Mod+Shift+Right".focus-monitor-right = _: { };
              "Mod+Shift+Down".focus-monitor-down = _: { };
              "Mod+Shift+Up".focus-monitor-up = _: { };

              # Move column / row
              "Mod+Ctrl+Left".move-column-left = _: { };
              "Mod+Ctrl+Right".move-column-right = _: { };
              "Mod+Ctrl+Down".move-window-down = _: { };
              "Mod+Ctrl+Up".move-window-up = _: { };

              # Move column to monitor
              "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = _: { };
              "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = _: { };
              "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = _: { };
              "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = _: { };

              # Window state
              "Mod+R".switch-preset-column-width = _: { };
              "Mod+Shift+R".switch-preset-column-width-back = _: { };
              "Mod+Ctrl+R".reset-window-height = _: { };
              "Mod+Ctrl+Shift+R".switch-preset-window-height = _: { };

              # Fine resize
              "Mod+Minus".set-column-width = "-5%";
              "Mod+Equal".set-column-width = "+5%";
              "Mod+Shift+Minus".set-window-height = "-5%";
              "Mod+Shift+Equal".set-window-height = "+5%";
              "Mod+M".maximize-window-to-edges = _: { };
              "Mod+F".maximize-column = _: { };
              "Mod+Shift+F".fullscreen-window = _: { };
              "Mod+Ctrl+F".expand-column-to-available-width = _: { };
              "Mod+C".center-column = _: { };
              "Mod+Ctrl+C".center-visible-columns = _: { };
              "Mod+V".toggle-window-floating = _: { };
              "Mod+Shift+V".switch-focus-between-floating-and-tiling = _: { };
              "Mod+W".toggle-column-tabbed-display = _: { };
              "Mod+O" = _: {
                props = {
                  repeat = false;
                };
                content = {
                  toggle-overview = _: { };
                };
              };
              "Mod+Tab".toggle-overview = _: { };

              # Workspaces
              "Mod+Page_Down".focus-workspace-down = _: { };
              "Mod+Page_Up".focus-workspace-up = _: { };
              "Mod+Shift+Page_Down".move-workspace-down = _: { };
              "Mod+Shift+Page_Up".move-workspace-up = _: { };
              "Mod+Ctrl+Page_Down".move-column-to-workspace-down = _: { };
              "Mod+Ctrl+Page_Up".move-column-to-workspace-up = _: { };

              "Mod+1".focus-workspace = 1;
              "Mod+2".focus-workspace = 2;
              "Mod+3".focus-workspace = 3;
              "Mod+4".focus-workspace = 4;
              "Mod+5".focus-workspace = 5;
              "Mod+6".focus-workspace = 6;
              "Mod+7".focus-workspace = 7;
              "Mod+8".focus-workspace = 8;
              "Mod+9".focus-workspace = 9;

              "Mod+Ctrl+1".move-column-to-workspace = 1;
              "Mod+Ctrl+2".move-column-to-workspace = 2;
              "Mod+Ctrl+3".move-column-to-workspace = 3;
              "Mod+Ctrl+4".move-column-to-workspace = 4;
              "Mod+Ctrl+5".move-column-to-workspace = 5;
              "Mod+Ctrl+6".move-column-to-workspace = 6;
              "Mod+Ctrl+7".move-column-to-workspace = 7;
              "Mod+Ctrl+8".move-column-to-workspace = 8;
              "Mod+Ctrl+9".move-column-to-workspace = 9;

              # Audio (Noctalia IPC: drives shell OSD + state)
              "XF86AudioRaiseVolume" = _: {
                props = {
                  allow-when-locked = true;
                };
                content = {
                  spawn-sh = "${noctaliaBin} ipc call volume increase";
                };
              };
              "XF86AudioLowerVolume" = _: {
                props = {
                  allow-when-locked = true;
                };
                content = {
                  spawn-sh = "${noctaliaBin} ipc call volume decrease";
                };
              };
              "XF86AudioMute" = _: {
                props = {
                  allow-when-locked = true;
                };
                content = {
                  spawn-sh = "${noctaliaBin} ipc call volume muteOutput";
                };
              };
              "XF86AudioMicMute" = _: {
                props = {
                  allow-when-locked = true;
                };
                content = {
                  spawn-sh = "${noctaliaBin} ipc call volume muteInput";
                };
              };

              # Brightness (Noctalia IPC)
              "XF86MonBrightnessUp" = _: {
                props = {
                  allow-when-locked = true;
                };
                content = {
                  spawn-sh = "${noctaliaBin} ipc call brightness increase";
                };
              };
              "XF86MonBrightnessDown" = _: {
                props = {
                  allow-when-locked = true;
                };
                content = {
                  spawn-sh = "${noctaliaBin} ipc call brightness decrease";
                };
              };

              # Screenshot
              "Print".screenshot = _: { };
              "Ctrl+Print".screenshot-screen = _: { };
              "Alt+Print".screenshot-window = _: { };

              # Misc
              "Mod+Shift+Slash".show-hotkey-overlay = _: { };
              "Mod+Shift+P".power-off-monitors = _: { };
              "Mod+Shift+E".quit = _: { };

              # Scroll workspace / move column
              "Mod+WheelScrollUp" = _: {
                props = {
                  cooldown-ms = 150;
                };
                content = {
                  focus-workspace-up = _: { };
                };
              };
              "Mod+WheelScrollDown" = _: {
                props = {
                  cooldown-ms = 150;
                };
                content = {
                  focus-workspace-down = _: { };
                };
              };
              "Mod+WheelScrollLeft" = _: {
                props = {
                  cooldown-ms = 150;
                };
                content = {
                  focus-column-right = _: { };
                };
              };
              "Mod+WheelScrollRight" = _: {
                props = {
                  cooldown-ms = 150;
                };
                content = {
                  focus-column-left = _: { };
                };
              };
              "Mod+Ctrl+WheelScrollUp" = _: {
                props = {
                  cooldown-ms = 150;
                };
                content = {
                  move-column-to-workspace-up = _: { };
                };
              };
              "Mod+Ctrl+WheelScrollDown" = _: {
                props = {
                  cooldown-ms = 150;
                };
                content = {
                  move-column-to-workspace-down = _: { };
                };
              };
            };
          };
        };
      };
    };

  flake.homeModules.niri =
    { pkgs, ... }:
    {
      xdg.configFile."niri/config.kdl".source = "${
        self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri
      }/niri-config.kdl";
    };

  flake.nixosModules.niri =
    { pkgs, ... }:
    {
      programs.niri.enable = true;

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
        hyprpolkitagent
        brightnessctl
        pavucontrol
        wl-clipboard
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
