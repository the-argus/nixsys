{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.kitty = let
    font = config.system.theme.font.monospace;
    opacity = config.system.theme.opacity;

    kittyColorFormat = key: (value: "#${value}");

    theme = with config.banner.palette; {
      foreground = base05;
      background = base00;
      selection_foreground = base05;
      selection_background = base02;

      cursor = base05;
      cursor_text_color = base00;
      url_color = link;

      # black
      color0 = ansi00;
      color8 = ansi00;

      # red
      color1 = ansi01;
      color9 = ansi01;

      # green
      color2 = ansi02;
      color10 = ansi02;

      # yellow
      color3 = ansi03;
      color11 = ansi03;

      # blue
      color4 = ansi04;
      color12 = ansi04;

      # magenta
      color5 = ansi05;
      color13 = ansi05;

      # cyan
      color6 = ansi06;
      color14 = ansi06;

      # white
      color7 = ansi07;
      color15 = ansi07;
    };

    themeFormatted = builtins.mapAttrs kittyColorFormat theme;
  in {
    enable = true;
    package = pkgs.kitty;

    settings =
      {
        font_family = font.name;
        font_size = font.size;
        background_opacity = opacity;

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
      }
      // themeFormatted;

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
