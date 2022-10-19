{
  pkgs,
  lib,
  config,
  settings,
  banner,
  ...
}: rec {
  commonInputs = rec {
    inherit (config.banner) palette;
    mkColor = color: "#${color}";
    bg = mkColor palette.highlight;
    inactive-bg = let
      opacity = config.system.theme.opacity;
    in
      (mkColor palette.base00)
      + (banner.lib.decimalToHex (
        lib.strings.toInt (255 * opacity)
      ));
    text = bg;
    inactive-text = bg;
    urgent-bg = mkColor palette.urgent;
    inactive-border = (mkColor palette.base00) + "00";

    transparent = "#00000000";
    indicator = "#424242";
    childBorder = mkColor palette.base02;
  };

  config = let
    inherit
      (commonInputs)
      banner
      mkColor
      bg
      inactive-bg
      text
      inactive-text
      urgent-bg
      inactive-border
      transparent
      indicator
      childBorder
      ;
  in rec {
    modifier = lib.mkDefault "Mod4"; # super key
    workspaceAutoBackAndForth = lib.mkDefault true;

    workspaceOutputAssign = let
      primaryWS = map (value: {
        workspace = value;
        output = "eDP-1";
      }) ["1" "2" "3" "4" "5"];
      secondaryWS = map (value: {
        workspace = value;
        output = "eDP-1 HDMI-A-1";
      }) ["1B" "2B" "3B" "4B" "5B"];
    in
      primaryWS ++ secondaryWS;

    window = {
      titlebar = false;
      border = 2;
      # vv one of "none" "vertical" "horizontal" "both" "smart" vv
      hideEdgeBorders = "smart";
      commands = let
        # this is the same as float criteria i believe
        float = app_id: {
          command = "floating enable";
          criteria = {inherit app_id;};
        };
        rmBorder = app_id: {
          command = "default_border 0";
          criteria = {inherit app_id;};
        };
      in [
        (float "nm-connection-editor")
        (float "qalculate-gtk")
        (float "Calculator")
        (float "keepassxc")
        (rmBorder "waybar")
      ];
    };

    floating = {
      titlebar = true;
      border = 4;
      inherit modifier;
      criteria = [
        {"title" = "Steam - Update News";}
        {"class" = "Pavucontrol";}
      ];
    };

    focus = {
      newWindow = "smart";
      followMouse = true;
      forceWrapping = false;
      mouseWarping = false;
    };

    fonts = let
      mainfont = config.system.theme.font.monospace;
    in {
      names = [(mainfont.name) "monospace"];
      style = "Bold";
      size = mainfont.size + 0.0;
    };

    colors = builtins.mapAttrs (name: value: lib.mkDefault value) rec {
      background = transparent;
      focused = {
        border = bg;
        background = bg;
        inherit text indicator childBorder;
      };
      focusedInactive = {
        border = inactive-border;
        background = inactive-bg;
        text = inactive-text;
        inherit indicator childBorder;
      };
      unfocused = focusedInactive;
      urgent = {
        border = urgent-bg;
        background = urgent-bg;
        inherit text indicator childBorder;
      };
      # placeholder window is default but can be configured
    };
    gaps = builtins.mapAttrs (name: value: lib.mkDefault value) rec {
      inner = 10;
      outer = 0;
      # theres also: horizontal vertical top left bottom right
      smartGaps = true;
      smartBorders = "off";
    };
    terminal = "${pkgs.${settings.terminal}}/bin/${settings.terminal}";
  };
}
