{
  pkgs,
  lib,
  banner,
  config,
  ...
}: let
  cfg = config.desktops.i3gaps;
  inherit (lib) mkEnableOption mkIf mkOption;
in {
  options.desktops.i3gaps = {
    enable = mkEnableOption "I3 window manager configuration.";
    package = mkOption {
      type = lib.types.package;
      default = pkgs.i3-gaps;
    };
    nobar = mkEnableOption "Alternate tiling WM workflow with no status bar.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      proggyfonts
    ];

    programs.i3status = {
      enable = true;
      general = {
        colors = false;
        interval = 5;
      };

      modules = let
        min_width = 200;
        align = "center";
      in {
        "wireless _first_" = {
          enable = config.system.hardware.usesWireless;
          position = 5;
          settings = {
            inherit align min_width;
            format_up = "wireless: %essid";
            format_down = "wireless:  down";
          };
        };
        "ethernet _first_" = {
          enable = config.system.hardware.usesEthernet;
          position = 6;
          settings = {
            inherit align min_width;
            format_up = "E: (%speed)";
            format_down = "E: down";
          };
        };
        cpu_usage = {
          enable = true;
          position = 3;
          settings = {
            inherit min_width align;
            format = "CPU %usage";
            max_threshold = 75;
            format_above_threshold = "DANGER: CPU %usage";
            degraded_threshold = 25;
            format_above_degraded_threshold = "CPU %usage";
          };
        };
        "battery all" = {
          enable = true;
          position = 7;
          settings = {
            inherit min_width align;
            format = "%status %percentage %emptytime";
            format_down = "empty";
            status_chr = "battery ^";
            status_bat = "battery -";
            status_unk = "battery ?";
            status_full = "battery -";
          };
        };
        "disk /" = {
          enable = true;
          position = 1;
          settings = {
            inherit align;
            min_width = min_width + 50;
            format = "NIXROOT : %free free / %total";
          };
        };
        "disk /home" = {
          enable = true;
          position = 2;
          settings = {
            inherit align;
            min_width = min_width + 50;
            format = "NIXHOME : %free free / %total";
          };
        };
        "tztime local" = {
          enable = true;
          position = 8;
          settings = {
            format = "%Y-%m-%d %I:%M";
          };
        };
        memory = {
          enable = true;
          position = 9;
          settings = {
            inherit min_width align;
            format = "%used | %available";
            format_degraded = "MEMORY < %available";
            threshold_degraded = "1G";
          };
        };
        # disabled modules
        ipv6.enable = false;
        load.enable = false;
      };
    };
    xsession.windowManager.i3 = let
      common = import ../../../lib/home-manager/i3-common.nix {
        inherit pkgs lib banner;
        inherit (config.system) theme;
        inherit (config.banner) palette;
        inherit (config.desktops) terminal;
        inherit (cfg) nobar;
        addQuotes = true;
      };
      inherit
        (common.commonInputs)
        bg
        inactive-bg
        text
        urgent-bg
        indicator
        ;
    in {
      enable = true;
      package = cfg.package;
      config =
        common.config
        # add everything that is unique to i3
        // {
          keybindings =
            common.config.keybindings
            // {
              "${common.config.modifier}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
              "Print" = "exec --no-startup-id \"$HOME/.local/bin/screenshot.sh\"";
            };
          startup =
            common.config.startup
            ++ (map (cmd: {command = cmd;})
              (
                (pkgs.callPackage ../../../lib/home-manager/xorg.nix {inherit config;}).mkAutoStart {
                  isI3 = true;
                  picomConfigLocation = "~/.config/i3/picom.conf";
                }
              ));
          bars = [
            {
              mode =
                if cfg.nobar
                then "hide"
                else "dock";
              hiddenState = "hide";
              position = "top";
              trayOutput = "primary"; # originally none
              fonts = {
                names = ["ProggySquare"];
                size = 12.0;
              };
              extraConfig = ''
                bindsym button1 nop
                tray_padding 0
                workspace_min_width 40
                i3bar_command i3bar
                status_command i3status
                modifier Mod1
              '';
              colors = rec {
                background = inactive-bg; #000000CC
                urgentWorkspace = {
                  border = urgent-bg;
                  background = urgent-bg;
                  inherit text;
                };
                inactiveWorkspace = {
                  border = inactive-bg;
                  background = inactive-bg;
                  text = indicator;
                };
                # i have a single monitor in all my setups
                activeWorkspace = inactiveWorkspace;
                focusedWorkspace = {
                  border = bg;
                  background = bg;
                  text = inactive-bg;
                };
              };
            }
          ];
        };
      extraConfig = '''';
    };

    home.file = {
      ".config/i3/picom.conf".text = ''
        # PICOM CONFIGURATION

        refresh-rate = 60


        corner-radius = 10.0;
        rounded-corners-exclude = [
            "_NET_WM_STATE@:32a = '_NET_WM_STATE_FULLSCREEN'",
            "window_type = 'popup_menu'",
            "window_type = 'dropdown_menu'",
            "window_type = 'menu'",
            "window_type = 'tooltip'",
            "WM_NAME@:s = 'menu'",
            "WM_NAME@:s = 'Eww - nobar'",
            #	"QTILE_FLOATING@:s = 'True'"
            "class_g     = 'i3bar'",
        ];
        round-borders = 1;
        round-borders-exclude = [
            "WM_NAME@:s = 'Discord Updater'",
            "WM_NAME@:s = 'Eww - nobar'",
            #	"QTILE_FLOATING@:s = 'True'",
            #  "QTILE_INTERNAL@:c"
        ];

        round-borders-rule = [
        #  "3:class_g      = 'XTerm'",
        #  "3:class_g      = 'URxvt'",
        #  "10:class_g     = 'Alacritty'",
        #  "15:class_g     = 'Signal'"
        ];

        shadow = true;
        shadow-radius = 15;
        shadow-opacity = 0.75;
        shadow-offset-x = -15;
        shadow-offset-y = -15;
        shadow-color = "#191724"

        shadow-exclude = [
            "window_type = 'popup_menu'",
            "window_type = 'dropdown_menu'",
            "window_type = 'menu'",
            "window_type = 'tooltip'",
            # firefox settings dropdown vvv
            "window_type = 'utility'",
            "WM_NAME@:s = 'menu'",
            "WM_NAME@:s = 'Eww - nobar'",
        #	"QTILE_FLOATING@:s != 'True'" #&& !QTILE_INTERNAL@:c"
        ];

        fading = true;
        fade-in-step = 0.1;
        fade-out-step = 0.1;
        fade-exclude = [
            "window_type = 'popup_menu'",
            "window_type = 'dropdown_menu'",
            "window_type = 'menu'",
            "window_type = 'utility'",
            "WM_NAME@:s = 'menu'"
        ]

        inactive-opacity = 1
        # Opacity of window titlebars and borders. (0.1 - 1.0, disabled by default)
        frame-opacity = 1.0

        # Let inactive opacity set by -i override the '_NET_WM_OPACITY' values of windows.
        inactive-opacity-override = false;

        # Default opacity for active windows. (0.0 - 1.0, defaults to 1.0)
        active-opacity = 1.0;

        # Dim inactive windows. (0.0 - 1.0, defaults to 0.0)
        # inactive-dim = 0.0

        # Specify a list of conditions of windows that should always be considered focused.
        focus-exclude = [
        ];

        # opacity-rule = []
        opacity-rule = [
        #  "80:class_g     = 'Rofi'"
           "100:class_g     = 'i3bar'",
        ];
        blur-method = "dual_kawase";
        blur-strength = 7;
        blur-size=1;

        blur-background = false;
        blur-background-frame = false;
        blur-background-fixed = false;
        # Exclude conditions for background blur.
        blur-background-exclude = [
            "window_type = 'popup_menu'",
            "window_type = 'utility'",
            "window_type = 'dropdown_menu'",
            "window_type = 'menu'",
            "class_g = 'rofi'",
            "class_g     = 'i3bar'",
            "WM_NAME@:s = 'Eww - nobar'",
        ];

        experimental-backends = true;
        backend = "glx";
        vsync = true;
        mark-wmwin-focused = true;
        mark-ovredir-focused = true;
        detect-rounded-corners = true;
        detect-client-opacity = true;
        detect-transient = true;
        detect-client-leader = true;
        no-use-damage = true;
        log-level = "info";
      '';
    };
  };
}
