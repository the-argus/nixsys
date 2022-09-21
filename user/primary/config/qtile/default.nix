{
  pkgs,
  picom,
  settings,
  ...
}: {
  home.file = let
    picomPkg =
      import ../../../../packages/picom.nix
      {
        inherit pkgs;
        inherit picom;
      };

    p = pkgs.callPackage ../../color.nix {};
  in {
    ".config/qtile" = {
      source = ./config;
      recursive = true;
    };

    ".config/qtile/autostart.sh" = {
      text = ''
        #!/bin/sh
        ${
          builtins.concatStringsSep "\n"
          ((pkgs.callPackage ../../lib/xorg.nix {inherit settings;})
            .mkAutoStart {
              picomConfigLocation = "~/.config/qtile/config/picom.conf";
            })
        }
      '';
      executable = true;
    };

    ".config/qtile/info.py".text = ''
      hardware = {
          "hasBattery": ${
        if settings.hasBattery
        then "True"
        else "False"
      }
      }
      terminal = "${pkgs.${settings.terminal}}/bin/${settings.terminal}"
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
