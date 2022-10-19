{
  pkgs,
  lib,
  config,
  settings,
  banner,
  ...
}: let
  inherit (config.system) theme;
  palette = config.banner.palette;
in rec {
  commonInputs = rec {
    inherit palette;
    mkColor = color: "#${color}";
    bg = mkColor palette.highlight;
    inactive-bg = let
      opacity = theme.opacity;

      pow = base: exp: let
        range = lib.lists.range 1 exp;
      in
        if exp <= 0
        then abort "this power function cannot handle exponents of 0 or less."
        else lib.lists.foldr (next: prev: base * prev) 1 range;

      stringToFloat = str: let
        splitFloat = (
          # turn digits into sets of integers and their length
          map (value: {
            value = (lib.strings.toInt value) + 0.0;
            length = builtins.stringLength value;
          })
          # split into digits
          (lib.strings.splitString "." str)
        );
        wholeNumber = let num = builtins.elemAt splitFloat 0; in num.value;
        fraction = let
          num = builtins.elemAt splitFloat 1;
          power = builtins.trace "10 to the power of ${builtins.toString num.length}: 
        ${builtins.toString (pow 10 num.length)}" (pow 10 num.length);
        in
          wholeNumber + fraction;

        floatToInt = float: let
          floatStr = builtins.toString float;
          floatStrSplit = lib.strings.splitString "." floatStr;
          intStr = builtins.elemAt floatStrSplit 0;
        in
          lib.strings.toInt intStr;
      in
        num.value / power;
    in
      (mkColor palette.base00)
      + (banner.lib.color.decimalToHex (floatToInt (256
        * (
          stringToFloat opacity
        ))));
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
      mainfont = theme.font.monospace;
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
