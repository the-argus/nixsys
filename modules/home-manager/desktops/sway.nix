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
      common = {
        banner = config.banner.palette;
        mkColor = color: "#${color}";
        bg = mkColor banner.highlight;
        inactive-bg = let
          opacity = config.system.theme.opacity;
        in
          (mkColor banner.base00)
          + (banner.lib.decimalToHex (
            lib.strings.toInt (255 * opacity)
          ));
        text = bg;
        inactive-text = bg;
        urgent-bg = mkColor banner.urgent;
        inactive-border = (mkColor banner.base00) + "00";

        transparent = "#00000000";
        indicator = "#424242";
        childBorder = mkColor banner.base02;
      };
      inherit
        (common)
        banner
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
        (import ../../../lib/home-manager/i3-common.nix {
          inherit config pkgs lib settings common;
        })
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
                "exec ${pkgs.networkmanagerapplet}/bin/nm-applet"
                "exec ${pkgs.blueman}/bin/blueman-applet"
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
              bg = "~/Wallpapers/matte/delorean.png";
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
          # Modkey used to refer to the second monitor
          set $secMod Mod2


          set $left h
          set $down j
          set $up k
          set $right l
          set $term kitty
          # use -G for dark icons
          set $menu wofi --show drun -I
          set $powermenu ~/.scripts/rofi-powermenu.sh

        ### Output configuration

          set $scr_aux HDMI-A-1
          set $scr_main eDP-1
          set $native_width 1920
          bindsym $mod+Return exec $term

          # Kill focused window
          bindsym $mod+Shift+q kill

          # Start your launcher
          bindsym $mod+space exec $menu

          floating_modifier $mod normal

          # Reload the configuration file
          bindsym $mod+Shift+r reload

          # Exit sway
          bindsym $mod+Control+p exit


        #
        # Moving around:
        #
          # Move your focus around
          bindsym $mod+$left focus left
          bindsym $mod+$down focus down
          bindsym $mod+$up focus up
          bindsym $mod+$right focus right

          # Move the focused window with the same, but add Shift
          bindsym $mod+Shift+$left move left
          bindsym $mod+Shift+$down move down
          bindsym $mod+Shift+$up move up
          bindsym $mod+Shift+$right move right
        #
        # Workspaces:
        #
          # Move workspaces from one monitor to another
          bindsym $mod+Control+Shift+$left  move workspace to output left
          bindsym $mod+Control+Shift+$right move workspace to output right
          bindsym $mod+Control+Shift+$up    move workspace to output up
          bindsym $mod+Control+Shift+$down  move workspace to output down

          # setup workspace variables
          set $ws_1A 1
          set $ws_2A 2
          set $ws_3A 3
          set $ws_4A 4
          set $ws_5A 5

          set $ws_1B 1B
          set $ws_2B 2B
          set $ws_3B 3B
          set $ws_4B 4B
          set $ws_5B 5B

          # assign workspaces to monitors
          workspace $ws_1A output $scr_main
          workspace $ws_2A output $scr_main
          workspace $ws_3A output $scr_main
          workspace $ws_4A output $scr_main
          workspace $ws_5A output $scr_main

          workspace $ws_1B output $scr_aux $scr_main
          workspace $ws_2B output $scr_aux $scr_main
          workspace $ws_3B output $scr_aux $scr_main
          workspace $ws_4B output $scr_aux $scr_main
          workspace $ws_5B output $scr_aux $scr_main

          # Switch to workspace
          bindsym $mod+1 workspace $ws_1A
          bindsym $mod+2 workspace $ws_2A
          bindsym $mod+3 workspace $ws_3A
          bindsym $mod+4 workspace $ws_4A
          bindsym $mod+5 workspace $ws_5A
          bindsym $secMod+1 workspace $ws_1B
          bindsym $secMod+2 workspace $ws_2B
          bindsym $secMod+3 workspace $ws_3B
          bindsym $secMod+4 workspace $ws_4B
          bindsym $secMod+5 workspace $ws_5B

          # Move focused container to workspace
          bindsym $mod+Shift+1 move container to workspace $ws_1A
          bindsym $mod+Shift+2 move container to workspace $ws_2A
          bindsym $mod+Shift+3 move container to workspace $ws_3A
          bindsym $mod+Shift+4 move container to workspace $ws_4A
          bindsym $mod+Shift+5 move container to workspace $ws_5A

          bindsym $secMod+Shift+1 move container to workspace $ws_1B
          bindsym $secMod+Shift+2 move container to workspace $ws_2B
          bindsym $secMod+Shift+3 move container to workspace $ws_3B
          bindsym $secMod+Shift+4 move container to workspace $ws_4B
          bindsym $secMod+Shift+5 move container to workspace $ws_5B


        #
        # Layout stuff:
        #
          bindsym $mod+b splith
          bindsym $mod+v splitv

          # Make the current focus fullscreen
          bindsym $mod+f fullscreen
          # Toggle the current focus between tiling and floating mode
          bindsym $mod+Shift+space floating toggle
          # Swap focus between the tiling area and the floating area
          bindsym $mod+Shift+f focus mode_toggle
          bindsym $mod+r mode "resize"

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
          swaybar_command = "waybar";
          position = "top";
          # mode = "hide";
          # hiddenState = "hide";
          # modifier = "Mod4";
        }

      '';
    };
  };
}
