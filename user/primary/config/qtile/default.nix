{
  pkgs,
  picom,
  settings,
  config,
  ...
}: {
  home.file = let
    picomPkg =
      import ../../../../packages/picom.nix
      {
        inherit pkgs;
        inherit picom;
      };
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

    ".config/qtile/color.py".text = with config.banner.palette; ''
      colors = {
          "bg": "#${base00}",
          "fg": "#${base05}",
          "fg_gutter": "#${base03}",
          "black": "#${base04}",
          "urgent": "#${urgent}",
          "warn": "#${warn}",
          "confirm": "#${confirm}",
          "link": "#${link}",
          "highlight": "#${highlight}",
          "hialt0": "#${hialt0}",
          "hialt1": "#${hialt1}",
          "hialt2": "#${hialt2}",

          "pfg08": "#${pfg08}",
          "pfg09": "#${pfg09}",
          "pfg0A": "#${pfg0A}",
          "pfg0B": "#${pfg0B}",
          "pfg0C": "#${pfg0C}",
          "pfg0D": "#${pfg0D}",
          "pfg0E": "#${pfg0E}",
          "pfg0F": "#${pfg0F}",

          "base00": "#${base00}",
          "base01": "#${base01}",
          "base02": "#${base02}",
          "base03": "#${base03}",
          "base04": "#${base04}",
          "base05": "#${base05}",
          "base06": "#${base06}",
          "base07": "#${base07}",
          "base08": "#${base08}",
          "base09": "#${base09}",
          "base0A": "#${base0A}",
          "base0B": "#${base0B}",
          "base0C": "#${base0C}",
          "base0D": "#${base0D}",
          "base0E": "#${base0E}",
          "base0F": "#${base0F}",
      }
    '';
  };
}
