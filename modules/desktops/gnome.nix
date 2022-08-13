{ config, options, pkgs, lib, ... }:
let
  cfg = config.desktops.gnome;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.desktops.gnome = {
    enable = mkEnableOption "Gnome Desktop Environment";
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    programs.dconf.enable = true;

    environment.systemPackages = with pkgs.gnomeExtensions; [
      appindicator
      transparent-window
      compiz-alike-windows-effect
      # compiz-windows-effect
      desktop-cube
      burn-my-windows
      blur-my-shell
      just-perfection
      keep-awake
      dash-to-panel
      (pkgs.callPackage ../../packages/fly-pie {})
    ];

    hardware.pulseaudio.enable = false;

    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);
  };
}
