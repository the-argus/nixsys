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
      color0 = base00;
      color8 = base01;

      # red
      color1 = base09;
      color9 = base09;

      # green
      color2 = base0A;
      color10 = base0A;

      # yellow
      color3 = base0B;
      color11 = base0B;

      # blue
      color4 = base0C;
      color12 = base0C;

      # magenta
      color5 = base0D;
      color13 = base0D;

      # cyan
      color6 = base0E;
      color14 = base0E;

      # white
      color7 = base05;
      color15 = base05;
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
