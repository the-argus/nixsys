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
    environment.systemPackages = with pkgs; [
      qt5.qtwayland
    ];
    # XDG Config
    xdg = {
      portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
        ];
      };
    };
  };
}
