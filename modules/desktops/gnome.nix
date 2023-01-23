{
  config,
  options,
  unstable,
  pkgs,
  lib,
  ...
}: let
  cfg = config.desktops.gnome;
  inherit (lib) mkIf mkEnableOption;
in {
  options.desktops.gnome = {
    enable = mkEnableOption "Gnome Desktop Environment";
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    desktops.wayland.enable = true;

    programs.dconf.enable = true;

    xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gnome];

    environment.systemPackages = with pkgs.gnomeExtensions;
      [
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
        gesture-improvements
        no-titlebar-when-maximized
        gtk-title-bar
        pkgs.myPackages.fly-pie
      ]
      ++ (with pkgs; [
        # maui apps (replacements for evince, totem, and gedit respectively
        # shelf
        # clip
        # nota
        # index-fm
        gnome.gnome-terminal
      ]);

    hardware.pulseaudio.enable = false;

    environment.gnome.excludePackages =
      (with pkgs; [
        gnome-photos
        gnome-tour
        gnome-text-editor
        gnome-console
        gnome-usage
        gnome-connections
        gnome-secrets
        gnome-console
        baobab
        simple-scan
        yelp
      ])
      ++ (with pkgs.gnome; [
        gnome-calculator
        gnome-logs
        gnome-disk-utility
        gnome-weather
        gnome-contacts
        gnome-clocks
        gnome-maps
        gnome-contacts
        nautilus
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
        baobab # disk usage analyzer
        file-roller
        gnome-calendar
        simple-scan
        gnome-font-viewer
        gnome-system-monitor
        yelp
        eog
        gnome-color-manager
      ]);
  };
}
