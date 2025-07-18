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
    home.packages = with pkgs; [
      swaylock-effects
      swayidle
      swaynag-battery
      sway-contrib.grimshot
      sway-contrib.inactive-windows-transparency
      swaycons
      clipman
    ];

    wayland.windowManager.sway = let
      common = import ../../../lib/home-manager/i3-common.nix {
        inherit pkgs lib banner;
        inherit (config.system) theme;
        inherit (config.banner) palette;
        inherit (config.desktops) terminal;
        inherit (cfg) nobar;
      };
    in {
      enable = true;
      checkConfig = false; # custom keyboard is in my home directory, not picked up during build
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
                  "swaybg --image ~/Wallpapers/${config.system.theme.wallpaper} --output \"*\""
                  ''swayidle -w timeout 300 'swaylock -f -c 000000' timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' before-sleep 'swaylock -f -c 000000''
                  ''swaynag-battery --threshold 30''
                  ''inactive-windows-transparency.py -o 0.8''
                  ''swaycons''
                  # "/bin/sh ~/.scripts/random-mpvpaper.sh"
                  ''wl-paste --watch clipman store''
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
            "eDP-1" = {
              pos = "0 520";
            };
            "HDMI-A-1" = {
              pos = "1920 0";
              mode = "2560x1440@144.0Hz";
            };
          };

          seat = {
            "*" = {
              # hide_cursor = "when-typing enable";
              xcursor_theme = "${config.system.theme.gtk.cursorTheme.name} 24";
            };
          };

          keybindings =
            common.config.keybindings
            // {
              "${common.config.modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

              "Print" = "exec grim -t png ~/Screenshots/$(date +%Y-%m-%d_%H-%m-%s).png";
              "${common.config.modifier}+Print" = "exec grim -t png -g \"$(slurp)\" ~/Screenshots/$(date +%Y-%m-%d_%H-%m-%s).png";
              "${common.config.modifier}+Return" = "exec ${config.desktops.terminal}/bin/${config.desktops.terminal.pname}";
              "${common.config.modifier}+M" = "exec clipman pick --tool=rofi";
            };

          input = {
            "type:touchpad" = {
              tap = "enabled";
              natural_scroll = "disabled";
            };

            "type:keyboard" = {
              xkb_layout = "custom";
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
