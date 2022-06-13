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
          cursorSettings = {
            text = "0x191724";
            cursor = "0x796268";
          };

          palette = {
            black = "0x6e6a86";
            red = "0xeb6f92";
            green = "0x9ccfd8";
            yellow = "0xf6c177";
            blue = "0x31748f";
            magenta = "0xc4a7e7";
            cyan = "0xebbcba";
            white = "0xe0def4";
          };
        in
        {
          primary = {
            background = "0x191724";
            foreground = "0xe0def4";
          };

          cursor = cursorSettings;
          vi_mode_cursor = cursorSettings;

          line_indicator = {
            foreground = "None";
            background = "None";
          };
          selection = {
            text = "CellForeground";
            background = "0x2A2738";
          };
          normal = palette;
          bright = palette;
        };
    };
  };
}
