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
    nobar = mkEnableOption "Alternate tiling WM workflow with no status bar.";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.sway = let
      common = import ../../../lib/home-manager/i3-common.nix {
        inherit config pkgs lib settings banner;
        inherit (cfg) nobar;
      };
      inherit
        (common)
        bg
        ;
      cfg = config.wayland.windowManager.sway;
    in {
      enable = true;
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
              # vidpaper = "~/Wallpapers/animated/video/compressed-koi.mp4";
            in
              mkStartup false ([
                  "exec ${pkgs.wlsunset}/bin/wlsunset -l 43.2 -L -77.6 -t 5000 -T 6500"
                  "exec ${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -c sway; swaymsg exit"
                  # "exec oguri"
                  # "exec mpvpaper -o \"--loop-file=inf --shuffle --scale=linear\" eDP-1 ${vidpaper}"
                  # "exec mpvpaper -o \"--loop-file=inf --shuffle --scale=linear\" HDMI-A-1 ${vidpaper}"
                  # "exec swaybg --image $imgpaper --output \"*\""
                  # "exec /bin/sh ~/.scripts/random-mpvpaper.sh"
                ]
                # neither of these even work
                ++ (lib.lists.optional
                  settings.usesWireless
                  "exec ${pkgs.networkmanagerapplet}/bin/nm-applet")
                ++ (lib.lists.optional
                  settings.usesBluetooth
                  "exec ${pkgs.blueman}/bin/blueman-applet"));
            commandsAlways =
              mkStartup true [
              ];
          in
            commandsOnce ++ commandsAlways;
          bars = [
          ];
          # in sway i use a floating bar and id like the windows to always match
          # its gaps from the left and right
          # gaps.smartGaps = false;
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

          keybindings = {
            "${cfg.config.modifier}+Return" = "exec ${cfg.config.terminal}";
            "${cfg.config.modifier}+Shift+q" = "kill";
            "${cfg.config.modifier}+d" = "exec ${cfg.config.menu}";

            "${cfg.config.modifier}+${cfg.config.left}" = "focus left";
            "${cfg.config.modifier}+${cfg.config.down}" = "focus down";
            "${cfg.config.modifier}+${cfg.config.up}" = "focus up";
            "${cfg.config.modifier}+${cfg.config.right}" = "focus right";

            "${cfg.config.modifier}+Left" = "focus left";
            "${cfg.config.modifier}+Down" = "focus down";
            "${cfg.config.modifier}+Up" = "focus up";
            "${cfg.config.modifier}+Right" = "focus right";

            "${cfg.config.modifier}+Shift+${cfg.config.left}" = "move left";
            "${cfg.config.modifier}+Shift+${cfg.config.down}" = "move down";
            "${cfg.config.modifier}+Shift+${cfg.config.up}" = "move up";
            "${cfg.config.modifier}+Shift+${cfg.config.right}" = "move right";

            "${cfg.config.modifier}+Shift+Left" = "move left";
            "${cfg.config.modifier}+Shift+Down" = "move down";
            "${cfg.config.modifier}+Shift+Up" = "move up";
            "${cfg.config.modifier}+Shift+Right" = "move right";

            "${cfg.config.modifier}+b" = "splith";
            "${cfg.config.modifier}+v" = "splitv";
            "${cfg.config.modifier}+f" = "fullscreen toggle";
            "${cfg.config.modifier}+a" = "focus parent";

            "${cfg.config.modifier}+s" = "layout stacking";
            "${cfg.config.modifier}+w" = "layout tabbed";
            "${cfg.config.modifier}+e" = "layout toggle split";

            "${cfg.config.modifier}+Shift+space" = "floating toggle";
            "${cfg.config.modifier}+space" = "focus mode_toggle";

            "${cfg.config.modifier}+1" = "workspace number 1";
            "${cfg.config.modifier}+2" = "workspace number 2";
            "${cfg.config.modifier}+3" = "workspace number 3";
            "${cfg.config.modifier}+4" = "workspace number 4";
            "${cfg.config.modifier}+5" = "workspace number 5";
            "${cfg.config.modifier}+6" = "workspace number 6";
            "${cfg.config.modifier}+7" = "workspace number 7";
            "${cfg.config.modifier}+8" = "workspace number 8";
            "${cfg.config.modifier}+9" = "workspace number 9";

            "${cfg.config.modifier}+Shift+1" = "move container to workspace number 1";
            "${cfg.config.modifier}+Shift+2" = "move container to workspace number 2";
            "${cfg.config.modifier}+Shift+3" = "move container to workspace number 3";
            "${cfg.config.modifier}+Shift+4" = "move container to workspace number 4";
            "${cfg.config.modifier}+Shift+5" = "move container to workspace number 5";
            "${cfg.config.modifier}+Shift+6" = "move container to workspace number 6";
            "${cfg.config.modifier}+Shift+7" = "move container to workspace number 7";
            "${cfg.config.modifier}+Shift+8" = "move container to workspace number 8";
            "${cfg.config.modifier}+Shift+9" = "move container to workspace number 9";

            "${cfg.config.modifier}+Shift+minus" = "move scratchpad";
            "${cfg.config.modifier}+minus" = "scratchpad show";

            "${cfg.config.modifier}+Shift+c" = "reload";
            "${cfg.config.modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

            "${cfg.config.modifier}+r" = "mode resize";
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

        bindsym Mod4+shift+e exec swaynag \
          -t warning \
          -m 'What do you want to do?' \
          -b 'Poweroff' 'systemctl poweroff' \
          -b 'Reboot' 'systemctl reboot'

      '';
    };
  };
}
