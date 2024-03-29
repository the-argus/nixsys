{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.desktops.qtile;
  derivations = {
    inherit (pkgs.myPackages) picom;
  };
  inherit (lib) mkIf mkEnableOption;
in {
  options.desktops.qtile = {
    enable = mkEnableOption "Qtile Window Manager";
  };

  config = mkIf cfg.enable {
    desktops.xorg.enable = true;

    services.xserver.windowManager.qtile = {
      enable = true;
    };

    environment.sessionVariables = {
      TERM = "kitty";
    };

    environment.systemPackages = with pkgs; [
      xmousepasteblock
      python310Packages.psutil # cpu widget
      xfce.xfce4-clipman-plugin
      dunst
      rofi-wayland
      flameshot
      derivations.picom

      libnotify # notify-send scripts
    ];
  };
}
