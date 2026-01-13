{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.desktops.i3gaps;
  derivations = {
    inherit (pkgs.myPackages) picom;
  };
  inherit (lib) mkIf mkEnableOption mkOption;
in {
  options.desktops.i3gaps = {
    enable = mkEnableOption "I3 Window Manager";
    package = mkOption {
      type = lib.types.package;
      default = pkgs.i3-gaps;
    };
    nobar = mkEnableOption "Alternate tiling WM workflow with no status bar.";
  };

  config = mkIf cfg.enable {
    # fix for i3blocks if i ever use it
    environment.pathsToLink = ["/libexec"];

    desktops.xorg.enable = true;

    services.xserver.windowManager.session = [
      {
        name = "i3";
        start = ''
          ${cfg.package}/bin/i3
          waitPID=$!
        '';
      }
    ];

    environment.systemPackages = with pkgs; [
      xmousepasteblock
      xfce.xfce4-clipman-plugin
      dunst
      rofi
      flameshot
      derivations.picom

      libnotify # notify-send scripts
    ];
  };
}
