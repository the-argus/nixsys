{
  pkgs,
  lib,
  banner,
  settings,
  config,
  ...
}: let
  cfg = config.desktops.sway;
  inherit (lib) mkEnableOption mkIf;
in {
  options.desktops.sway = {
    enable = mkEnableOption "Sway window manager configuration.";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.sway = let
      common = import ../../../lib/home-manager/i3-common.nix {
        inherit config pkgs lib settings banner;
      };
      inherit
        (common)
        palette
        mkColor
        bg
        inactive-bg
        text
        inactive-text
        urgent-bg
        inactive-border
        transparent
        indicator
        childBorder
        ;
    in {
      enable = true;
      package = pkgs.i3-gaps;
      config =
        common.config
        # add everything that is unique to i3
        // {
          # startup = ...
          startup = let
            mkStartup = always: list:
              map (command: {
                inherit command always;
              })
              list;

            commandsOnce = let
              vidpaper = "~/Wallpapers/animated/video/compressed-koi.mp4";
            in
              mkStartup false [
                "exec ${pkgs.wlsunset}/bin/wlsunset -l 43.2 -L -77.6 -t 5000 -T 6500"
                # "exec oguri"
                # "exec mpvpaper -o \"--loop-file=inf --shuffle --scale=linear\" eDP-1 ${vidpaper}"
                # "exec mpvpaper -o \"--loop-file=inf --shuffle --scale=linear\" HDMI-A-1 ${vidpaper}"
                # "exec swaybg --image $imgpaper --output \"*\""
                # "exec /bin/sh ~/.scripts/random-mpvpaper.sh"

                # neither of these even work
                ${
                  if settings.usesWireless
                  then "exec ${pkgs.networkmanagerapplet}/bin/nm-applet"
                  else ""
                }
                ${
                  if settings.usesBluetooth
                  then "exec ${pkgs.blueman}/bin/blueman-applet"
                  else ""
                }
              ];
            commandsAlways =
              mkStartup true [
              ];
          in
            commandsOnce ++ commandsAlways;
          bars = [
          ];
          # in sway i use a floating bar and id like the windows to always match
          # its gaps from the left and right
          gaps.smartGaps = false;
          menu = "${pkgs.wofi}/bin/wofi --show drun -I";

          output = {
            "*" = {
              bg = "~/Wallpapers/matte/delorean.png fill";
            };
            "eDP-1" = {
              pos = "0 520";
            };
            "HDMI-A-1" = {
              pos = "1920 0";
            };
          };

          seat = {
            "*" = {
              hide_cursor = "when-typing enable";
              xcursor_theme = "${config.system.theme.gtk.cursorTheme.name} 24";
            };
          };

          modes = {
            resize = let
              cfg = config.wayland.windowManager.sway;
            in {
              "${cfg.config.left}" = "resize shrink width 10 px";
              "${cfg.config.down}" = "resize grow height 10 px";
              "${cfg.config.up}" = "resize shrink height 10 px";
              "${cfg.config.right}" = "resize grow width 10 px";
              "Left" = "resize shrink width 10 px";
              "Down" = "resize grow height 10 px";
              "Up" = "resize shrink height 10 px";
              "Right" = "resize grow width 10 px";
              "Escape" = "mode default";
              "Return" = "mode default";
            };
          };

          input = {
            # "1739:52775:DLL0945:00_06CB:CE27_Touchpad"
            "Touchpad" = {
              tap = "enabled";
              natural_scroll = "disabled";
            };
          };
        };
      extraConfig = ''
          set $mod Mod4
          set $menu wofi --show drun -I
          bindsym $mod+Control+space exec $menu

          # Exit sway
          bindsym $mod+Control+p exit

        #
        # Volume and brightness:
        #
          bindsym XF86MonBrightnessUp exec xbacklight -inc 10
          bindsym XF86MonBrightnessDown exec xbacklight -dec 10
          bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +10%
          bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -10%
          bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle

        #
        # Screenshots
        #
          # Take a screenshot with all output and save it into screenshots
          bindsym Print exec grim -t png ~/Screenshots/$(date +%Y-%m-%d_%H-%m-%s).png

          # Take a Screenshot with the region select
          bindsym $mod+Print exec grim -t png -g "$(slurp)" ~/Screenshots/$(date +%Y-%m-%d_%H-%m-%s).png

        #
        # Utilities
        #
          bindsym XF86Calculator exec qalculate-gtk

        bar {
          swaybar_command waybar
          position top
          # mode = "hide";
          # hiddenState = "hide";
          # modifier = "Mod4";
        }

      '';
    };
  };
}
