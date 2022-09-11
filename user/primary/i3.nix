{
  pkgs,
  settings,
  ...
}: {
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    config = let
      colors = (pkgs.callPackage ./themes.nix {}).scheme;
    in {
      modifier = "Mod4"; # super key
      workspaceAutoBackAndForth = true;

      colors = let
        mkColor = color: "#${color}";
        bg = mkColor colors.hi1;
        inactive-bg = (mkColor colors.bg) + "CC";
        text = bg;
        inactive-text = bg;
        urgent-bg = colors.red;
        inactive-border = (mkColor colors.bg) + "00";

        transparent = "#00000000";
        indicator = "#424242";
        childBorder = mkColor colors.altfg;
      in rec {
        background = transparent;
        focused = {
          border = bg;
          background = bg;
          inherit text indicator childBorder;
        };
        focusedInactive = {
          border = inactive-border;
          background = inactive-bg;
          text = inactive-text;
          inherit indicator childBorder;
        };
        unfocused = focusedInactive;
        urgent = {
          border = urgent-bg;
          background = urgent-bg;
          inherit text indicator childBorder;
        };
        # placeholder window is default but can be configured
      };

      gaps = {
        inner = 10;
        outer = 0;
        # theres also: horizontal vertical top left bottom right
        smartGaps = "on";
        smartBorders = "off";
      };
      terminal = "${pkgs.${settings.terminal}}/bin/${settings.terminal}";

      startup =
        map (cmd: {command = cmd;})
        (
          (
            pkgs.callPackage ./lib/xorg.nix
            {
              picomConfigLocation = "~/.config/i3/picom.conf";
              inherit settings;
            }
          )
          .autoStart
        );
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
          "WM_NAME@:s = 'menu'"
          #	"QTILE_FLOATING@:s = 'True'"
      ];
      round-borders = 1;
      round-borders-exclude = [
          "WM_NAME@:s = 'Discord Updater'"
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
          "WM_NAME@:s = 'menu'"
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
}
