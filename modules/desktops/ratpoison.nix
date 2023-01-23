{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.desktops.ratpoison;
  derivations = {
    inherit (pkgs.myPackages) picom;
  };
  inherit (lib) mkIf mkEnableOption;
in {
  options.desktops.ratpoison = {
    enable = mkEnableOption "Ratpoison Window Manager";
  };

  config = mkIf cfg.enable {
    desktops.xorg.enable = true;

    services.xserver.windowManager.ratpoison = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      ratpoison.contrib
      rofi-wayland
      flameshot
      derivations.picom
    ];
  };
}
