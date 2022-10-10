{
  pkgs,
  settings,
  config,
  ...
}: {
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
    
    # translate nix banner palette into python
    ".config/qtile/color.py".text = with config.banner.palette; ''
      colors = {
          ${builtins.concatStringsSep "\n"
        (lib.attrsets.mapAttrsToList
          (name: value: "\"${name}\": \"#${value}\"")
          config.banner.palette)}
      }
    '';
  };
}
