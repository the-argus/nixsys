{ lib, pkgs, ... }:
{
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

      font =
        let
          main = "Fira Code";
        in
        {
          size = 11;
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

      colors =
        let
          palette = import ./color.nix { };

          cursorSettings = {
            text = palette.bg;
            cursor = palette.altfg;
          };

          alacrittyPalette = {
            black = palette.black;
            red = palette.red;
            green = palette.green;
            yellow = palette.yellow;
            blue = palette.blue;
            magenta = palette.magenta;
            cyan = palette.cyan;
            white = palette.white;
          };
        in
        {
          primary = {
            background = palette.bg;
            foreground = palette.fg;
          };

          cursor = cursorSettings;
          vi_mode_cursor = cursorSettings;

          line_indicator = {
            foreground = "None";
            background = "None";
          };
          selection = {
            text = "CellForeground";
            background = palette.altbg;
          };
          normal = alacrittyPalette;
          bright = alacrittyPalette;
        };
    };
  };
}
