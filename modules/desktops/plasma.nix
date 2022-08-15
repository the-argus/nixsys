{ config, options, unstable, pkgs, lib, ... }:
let
  cfg = config.desktops.plasma;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.desktops.plasma = {
    enable = mkEnableOption "KDE Plasma Desktop Environment";
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.desktopManager.plasma5 = {
      enable = true;
      # excludePackages = with pkgs; [
      #   elisa
      #   gwenview
      #   okular
      #   konsole
      #   dolphin
      #   plasma-systemmonitor
      # ] ++ (with pkgs.plasma5Packages; [
      #   kwallet
      #   kwallet-pam
      #   kwalletmanager
      #   khelpcenter
      #   kinfocenter
      #   plasma-systemmonitor
      #   dolphin
      # ]);
      # mobile = {
      #   enable = false;
      #   installRecommendedSoftware = false;
      # };
    };

    desktops.wayland.enable = true;

    # environment.systemPackages = with pkgs; [
    # ] ++ (with pkgs.plasma5Packages; [
    # ]);
  };
}
