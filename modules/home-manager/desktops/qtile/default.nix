{
  pkgs,
  lib,
  config,
  banner,
  ...
}: let
  cfg = config.desktops.qtile;
  inherit (lib) mkEnableOption mkIf;
in {
  options.desktops.qtile = {
    enable = mkEnableOption "Qtile window manager configuration.";
  };

  config = mkIf cfg.enable {
    home.file = let
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
            ((pkgs.callPackage ../../../../lib/home-manager/xorg.nix {inherit config;})
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
          if config.system.hardware.hasBattery
          then "True"
          else "False"
        }
        }
        useDvorak = ${
          if config.keyboard.dvorak.enable
          then "True"
          else "False"
        }
        terminal = "${config.desktops.terminal}/bin/${config.desktops.terminal.pname}"
      '';

      # translate nix banner palette into python
      ".config/qtile/color.py".text = let
        colorPalette = banner.lib.util.removeMeta config.banner.palette;
      in ''
        colors = {
            ${builtins.concatStringsSep "\n"
          (lib.attrsets.mapAttrsToList
            (name: value: "\"${name}\": \"#${value}\",")
            colorPalette)}
        }
      '';
    };
  };
}
