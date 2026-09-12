{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.hevel;

  package = pkgs.myPackages.hevel;
in {
  options.programs.hevel = {
    enable = lib.mkEnableOption "enable hevel window manager as login option";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment = {
          systemPackages = [package];
        };

        systemd.user.targets.hevel-session = {
          description = "hevel compositor session";
          documentation = ["man:systemd.special(7)"];
          bindsTo = ["graphical-session.target"];
          wants = ["graphical-session-pre.target"];
          after = ["graphical-session-pre.target"];
        };

        # To make a hevel session available if a display manager like SDDM is enabled:
        services.displayManager.sessionPackages = package;
      }

      # this attrset is from wayland-session.nix in nixpkgs
      {
        security = {
          polkit.enable = true;
          pam.services.swaylock = {};
        };

        programs = {
          dconf.enable = lib.mkDefault true;
          xwayland.enable = lib.mkDefault true;
        };

        services.graphical-desktop.enable = true;

        xdg.portal.wlr.enable = true;
        xdg.portal.extraPortals = true [
          pkgs.xdg-desktop-portal-gtk
        ];

        # Window manager only sessions (unlike DEs) don't handle XDG
        # autostart files, so force them to run the service
        services.xserver.desktopManager.runXdgAutostartIfNone = lib.mkDefault true;
      }
    ]
  );
}
