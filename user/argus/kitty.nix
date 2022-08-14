{ pkgs, lib, unstable, ... }:
{
  programs.kitty =
    let
      colors = import ./color.nix;

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
        background_opacity = "0.8";

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

        allow_remote_control = "socket-only";
        listen_on = "unix:/tmp/kitty";
      } // themeFormatted;

      keybindings = {
        "ctrl+shift+r" = "discard_event";
        "ctrl+shift+n" = "discard_event"; # open new window
        "ctrl+shift+t" = "discard_event"; # open new tab
        "ctrl+shift+w" = "discard_event"; # close window
        "ctrl+shift+space" = "show_scrollback";
        "ctrl+shift+h" = "discard_event";

        "ctrl+minus" = "change_font_size all -2.0";
        "ctrl+shift+kp_subtract" = "change_font_size all -2.0";
        "ctrl+equal" = "change_font_size all +2.0";
        "ctrl+plus" = "change_font_size all +2.0";
        "ctrl+kp_add" = "change_font_size all +2.0";
      };
    };
}
