{
  lib,
  pkgs,
  config,
  ...
}: {
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
        main = (pkgs.callPackage ./themes.nix {}).font.monospace.name;
      in {
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
        alacrittyColorFormat = name: color: "0x${color}";

        cursorSettings = builtins.mapAttrs alacrittyColorFormat {
          text = palette.base00;
          cursor = palette.base05;
        };

        alacrittyPalette = builtins.mapAttrs alacrittyColorFormat {
          black = palette.base03;
          red = palette.base09;
          green = palette.base0D;
          yellow = palette.base0A;
          blue = palette.base0C;
          magenta = palette.base0E;
          cyan = palette.base0B;
          white = palette.base05;
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
