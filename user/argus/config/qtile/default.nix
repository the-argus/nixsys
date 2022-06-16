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

      p = import ../../color.nix { };
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
          ${pkgs.xsuspender}/bin/xsuspender &
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


      ".config/qtile/color.py".text = ''
        colors = {
            "bg": "#${p.altbg2}",
            "fg": "#${p.white}",
            "fg_gutter": "#${p.cyan}",
            "black": "#${p.bg}",
            "red": "#${p.red}",
            "green": "#${p.green}",
            "yellow": "#${p.yellow}",
            "blue": "#${p.blue}",
            "magenta": "#${p.magenta}",
            "cyan": "#${p.cyan}",
            "white": "#${p.white}",
            "orange": "#${p.black}",
            "pink": "#${p.altbg}"
        }
      '';
    };
}
