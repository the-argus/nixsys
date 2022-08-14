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
      #   # kwallet
      #   # kwallet-pam
      #   # kwalletmanager
      # ] ++ (with pkgs.plasma5Packages; [
      #   
      # ]);
      # mobile = {
      #   enable = false;
      #   installRecommendedSoftware = false;
      # };
    };

    desktops.wayland.enable = true;

    environment.systemPackages = with pkgs; [
    ] ++ (with pkgs.plasma5Packages; [
    ]);

    hardware.pulseaudio.enable = false;
  };
}
