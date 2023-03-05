{
  pkgs,
  lib,
  banner,
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
        inherit pkgs lib banner;
        inherit (config.system) theme;
        inherit (config.banner) palette;
        inherit (config.desktops) terminal;
        inherit (cfg) nobar;
      };
      inherit
        (common)
        bg
        ;
    in {
      enable = true;
      config =
        common.config
        # add everything that is unique to sway
        // {
          # startup = ...
          startup = let
            mkStartup = always: list:
              map
              (command: {
                inherit command always;
              })
              list;

            commandsOnce = let
              # vidpaper = "~/Wallpapers/animated/video/compressed-koi.mp4";
            in
              mkStartup false ([
                  "${pkgs.wlsunset}/bin/wlsunset -l 43.2 -L -77.6 -t 5000 -T 6500"
                  # "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -c sway; swaymsg exit"
                  # "oguri"
                  # "mpvpaper -o \"--loop-file=inf --shuffle --scale=linear\" eDP-1 ${vidpaper}"
                  # "mpvpaper -o \"--loop-file=inf --shuffle --scale=linear\" HDMI-A-1 ${vidpaper}"
                  # "swaybg --image $imgpaper --output \"*\""
                  # "/bin/sh ~/.scripts/random-mpvpaper.sh"
                ]
                # neither of these even work
                ++ (lib.lists.optional
                  config.system.hardware.usesWireless
                  "${pkgs.networkmanagerapplet}/bin/nm-applet")
                ++ (lib.lists.optional
                  config.system.hardware.usesBluetooth
                  "${pkgs.blueman}/bin/blueman-applet"));
            commandsAlways =
              mkStartup true [
              ];
          in
            common.config.startup ++ (commandsOnce ++ commandsAlways);
          bars = [
          ];
          # in sway i use a floating bar and id like the windows to always match
          # its gaps from the left and right
          # gaps.smartGaps = false;
          gaps.inner = 0;
          # menu = "${pkgs.wofi}/bin/wofi --show drun -I";

          output = {
            "*" = {
              bg = "~/Wallpapers/rose/delorean.png fill";
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

          keybindings =
            common.config.keybindings
            // {
              "${common.config.modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

              "Print" = "exec grim -t png ~/Screenshots/$(date +%Y-%m-%d_%H-%m-%s).png";
              "${common.config.modifier}+Print" = "exec grim -t png -g \"$(slurp)\" ~/Screenshots/$(date +%Y-%m-%d_%H-%m-%s).png";
            };

          input = {
            # "1739:52775:DLL0945:00_06CB:CE27_Touchpad"
            "Touchpad" = {
              tap = "enabled";
              natural_scroll = "disabled";
            };

            "type:keyboard" = {
              xkb_options = "ctrl:swapcaps";
            };
          };
        };
      extraConfig = ''
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
