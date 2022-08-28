{ pkgs, picom, hardware, ... }: {
  home.file =
    let
      picomPkg = import ../../../../packages/picom.nix
        { inherit pkgs; inherit picom; };

      laptopAutostart = ''
        # laptop has bluetooth and wireless
        ${pkgs.blueman}/bin/blueman-applet &
        ${pkgs.networkmanagerapplet}/bin/nm-applet &
      '';

      pcAutostart = ''
        # i use a mouse on my pc, so theres middleclick
        ${pkgs.xmousepasteblock}/bin/xmousepasteblock &
      '';

      p = pkgs.callPackage ../../color.nix { };
    in
    {
      ".config/qtile" = {
        source = ./config;
        recursive = true;
      };

      ".config/qtile/autostart.sh" = {
        text = ''
          #!/bin/sh

          ${pkgs.dunst}/bin/dunst &
          ${pkgs.xfce.xfce4-clipman-plugin}/bin/xfce4-clipman &
          ${pkgs.xclip}/bin/xclip &

          # start picom fr
          # ${picomPkg}/bin/picom --config ~/.config/qtile/config/picom.conf &

          # start picom IF we have it installed
          picom --config ~/.config/qtile/config/picom.conf &

          # restore feh wallpaper
          $HOME/.fehbg
          ${if hardware == "laptop" then laptopAutostart else ""}
          ${if hardware == "pc" then pcAutostart else ""}
        '';
        executable = true;
      };

      ".config/qtile/info.py".text = ''
        hardware = "${hardware}"
      '';

      # use weird colors that dont match names...
      ".config/qtile/color.py".text = ''
        colors = {
            "bg": "#${p.altbg2}",
            "fg": "#${p.white}",
            "fg_gutter": "#${p.altbg3}",
            "black": "#${p.bg}",
            "red": "#${p.red}",
            "green": "#${p.green}",
            "yellow": "#${p.hi2}",
            "blue": "#${p.blue}",
            "magenta": "#${p.hi1}",
            "cyan": "#${p.altbg3}",
            "white": "#${p.white}",
            "orange": "#${p.black}",
            "pink": "#${p.hi4}"
        }
      '';
    };
}
