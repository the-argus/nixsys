{
  pkgs,
  lib,
  config,
  settings,
  banner,
  nobar ? false,
  addQuotes ? false,
  ...
}: let
  inherit (config.system) theme;
  palette = config.banner.palette;
in rec {
  commonInputs = rec {
    keys = {
      left = "h";
      down = "j";
      up = "k";
      right = "l";
    };
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
        else lib.lists.foldr (_: prev: base * prev) 1 range;

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
        # get first value normally (whole number stays)
        wholeNumber = let num = builtins.elemAt splitFloat 0; in num.value;
        # get fraction part separately)
        fraction = let
          num = builtins.elemAt splitFloat 1;
          power = pow 10 num.length;
        in
          num.value / power;
      in
        wholeNumber + fraction;

      floatToInt = float: let
        floatStr = builtins.toString float;
        floatStrSplit = lib.strings.splitString "." floatStr;
        intStr = builtins.elemAt floatStrSplit 0;
      in
        lib.strings.toInt intStr;
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
      bg
      inactive-bg
      text
      inactive-text
      urgent-bg
      inactive-border
      transparent
      indicator
      childBorder
      keys
      ;
  in rec {
    modifier = "Mod4"; # super key
    workspaceAutoBackAndForth = lib.mkDefault true;

    keybindings = let
      mkCommand =
        if addQuotes
        then command: "exec --no-startup-id \"${command}\""
        else command: "exec --no-startup-id ${command}";

      nobarKeys = {
        "${modifier}+Tab" = "workspace back_and_forth";
        "${modifier}+i" = mkCommand "$HOME/.local/bin/i3/isolate";
        "${modifier}+Shift+i" = mkCommand "$HOME/.local/bin/i3/isolate undo";
        "${modifier}+s" = mkCommand "rofi -show combi -modes combi -combi-modes window,drun";
      };

      # keys that shouldnt exist when using nobar
      noNobarKeys = {
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";

        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";
      };
    in
      {
        "${modifier}+Return" = "exec ${settings.terminal}";
        "${modifier}+Shift+q" = "kill";

        "${modifier}+${keys.left}" = "focus left";
        "${modifier}+${keys.down}" = "focus down";
        "${modifier}+${keys.up}" = "focus up";
        "${modifier}+${keys.right}" = "focus right";

        "${modifier}+Shift+${keys.left}" = "move left";
        "${modifier}+Shift+${keys.down}" = "move down";
        "${modifier}+Shift+${keys.up}" = "move up";
        "${modifier}+Shift+${keys.right}" = "move right";

        "${modifier}+b" = "split b";
        "${modifier}+v" = "split v";
        "${modifier}+f" = "fullscreen toggle";

        "${modifier}+p" = mkCommand "bwmenu";

        "${modifier}+BackSpace" = mkCommand "$HOME/.local/bin/switch-kb-layout.sh";

        "XF86Calculator" = mkCommand "qalculate-gtk";
        "XF86AudioRaiseVolume" = mkCommand "$HOME/.local/bin/volume.sh up";
        "XF86AudioLowerVolume" = mkCommand "$HOME/.local/bin/volume.sh down";
        "XF86AudioMute" = mkCommand "$HOME/.local/bin/volume.sh mute";
        "XF86MonBrightnessDown" = mkCommand "$HOME/.local/bin/brightness.sh down";
        "XF86MonBrightnessUp" = mkCommand "$HOME/.local/bin/brightness.sh up";

        "${modifier}+space" = mkCommand "$HOME/.local/bin/rofi-launchpad.sh";

        "${modifier}+Shift+space" = "floating toggle";

        "${modifier}+Shift+minus" = "move scratchpad";
        "${modifier}+minus" = "scratchpad show";

        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+r" = "restart";

        "${modifier}+r" = "mode resize";
      }
      // (
        if nobar
        then nobarKeys
        else noNobarKeys
      );

    modes = {
      resize = {
        ${keys.left} = "resize shrink width 10 px or 10 ppt";
        ${keys.down} = "resize grow height 10 px or 10 ppt";
        ${keys.up} = "resize shrink height 10 px or 10 ppt";
        ${keys.right} = "resize grow width 10 px or 10 ppt";
        "Escape" = "mode default";
        "Return" = "mode default";
        "${modifier}+r" = "mode default";
      };
    };

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
        float = class: {
          command = "floating enable";
          criteria = {inherit class;};
        };
        rmBorder = class: {
          command = "default_border 0";
          criteria = {inherit class;};
        };
      in [
        (float "nm-connection-editor")
        (float "Qalculate-gtk")
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

    colors = rec {
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
    gaps = builtins.mapAttrs (_: value: lib.mkDefault value) rec {
      inner = 10;
      outer = 0;
      # theres also: horizontal vertical top left bottom right
      smartGaps = true;
      smartBorders = "off";
    };
    terminal = "${pkgs.${settings.terminal}}/bin/${settings.terminal}";
  };
}
