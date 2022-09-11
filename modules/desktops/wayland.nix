{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.desktops.wayland;
  inherit (lib) mkIf mkEnableOption;
in {
  options.desktops.wayland = {
    enable = mkEnableOption "Wayland Display";
  };

  config = mkIf cfg.enable {
    # XDG Config
    xdg = {
      portal = {
        enable = true;
        wlr.enable = true;
        # gtkUsePortal = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          # xdg-desktop-portal-gtk
          #   xdg-desktop-portal-kde
        ];
      };
    };
  };
}
