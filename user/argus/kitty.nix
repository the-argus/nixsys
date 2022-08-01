{ pkgs, lib, unstable, ... }:
{
  programs.kitty =
    let
      colors = import ./color.nix {};

      kittyColorFormat = (key: (value: "#${value}"));

      theme = with colors; {
        foreground = fg;
        background = bg;
        selection_foreground = fg;
        selection_background = altbg;

        cursor = altfg;
        cursor_text_color = bg;
        url_color = magenta;

        # black
        color0 = altfg2;
        color8 = black;

        # red
        color1 = red;
        color9 = red;

        # green
        color2 = green;
        color10 = green;

        # yellow
        color3 = yellow;
        color11 = yellow;

        # blue
        color4 = blue;
        color12 = blue;

        # magenta
        color5 = magenta;
        color13 = magenta;

        # cyan
        color6 = cyan;
        color14 = cyan;

        # white
        color7 = white;
        color15 = white;
      };

      themeFormatted = builtins.mapAttrs kittyColorFormat theme;
    in
    {
      enable = true;
      package = unstable.kitty;

      settings = {
        font_family = "Fira Code";
        font_size = 14;

        # no bells. Ever.
        enable_audio_bell = false;
        bell_on_tab = false;

        confirm_os_window_close = 0;

        open_url_with = "default";

        cursor_shape = "underline";

        adjust_line_height = 0;
        adjust_column_width = 0;

        disable_ligatures = "never";

        window_margin_width = 5;
      } // themeFormatted;

      keybindings = { };
    };
}
