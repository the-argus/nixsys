{config, ...}: {
  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        opacity = 1.0;
        padding = {
          x = 8;
          y = 2;
        };
        dynamic_padding = true;
        decorations = "none";
        dynamic_title = true;
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      font = let
        main = config.system.theme.font.monospace.name;
        # main = "TamzenForPowerline";
      in {
        # size = 13.5; # TamzenForPowerline
        size = 9;
        normal.family = main;
        bold.family = main;
        italic.family = main;
        bold_italic.family = main;

        bold.style = "Bold";
        italic.style = "Semibold Italic";
        bold_italic.style = "Bold Italic";
      };

      cursor.style = {
        shape = "Underline";
        blinking = "On";
      };

      colors = let
        inherit (config.banner) palette;
        prepend0x = color: "0x${color}";
        alacrittyColorFormat = _: color: "0x${color}";

        cursorSettings = builtins.mapAttrs alacrittyColorFormat {
          text = palette.base00;
          cursor = palette.base05;
        };

        alacrittyPalette = builtins.mapAttrs alacrittyColorFormat {
          black = palette.ansi00;
          red = palette.ansi01;
          green = palette.ansi02;
          yellow = palette.ansi03;
          blue = palette.ansi04;
          magenta = palette.ansi05;
          cyan = palette.ansi06;
          white = palette.ansi07;
        };
      in {
        primary = builtins.mapAttrs alacrittyColorFormat {
          background = palette.base00;
          foreground = palette.base05;
        };

        cursor = cursorSettings;
        vi_mode_cursor = cursorSettings;

        line_indicator = {
          foreground = "None";
          background = "None";
        };
        selection = {
          text = "CellForeground";
          background = prepend0x palette.base02;
        };
        normal = alacrittyPalette;
        bright = alacrittyPalette;
      };
    };
  };
}
