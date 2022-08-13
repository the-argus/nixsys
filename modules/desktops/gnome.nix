{ config, options, unstable, pkgs, lib, ... }:
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

    desktops.wayland.enable = true;

    programs.dconf.enable = true;

    xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];

    environment.systemPackages = with pkgs.gnomeExtensions; [
      # maui apps (replacements for evince, totem, and gedit respectively
      (unstable) shelf clip nota index-fm
      pkgs.sakura # preferred gtk terminal emulator
      appindicator
      # unstable.gnomeExtensions.transparent-window
      # compiz-alike-windows-effect
      # compiz-windows-effect
      # desktop-cube
      burn-my-windows
      blur-my-shell
      just-perfection
      unstable.gnomeExtensions.keep-awake
      dash-to-panel
      no-title-bar
      (pkgs.callPackage ../../packages/fly-pie { })
    ];

    hardware.pulseaudio.enable = false;

    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      gnome-terminal
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
