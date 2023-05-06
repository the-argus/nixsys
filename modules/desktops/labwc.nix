{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.desktops.labwc;
  inherit (lib) mkIf mkEnableOption mkOption types literalExpression mkDefault;
in {
  options.desktops.labwc = {
    enable = mkEnableOption "Labwc Window Manager";
    enableXWayland = mkOption {
      type = types.bool;
      default = true;
      description = "XWayland support";
    };
    package = mkOption {
      type = types.package;
      default = pkgs.myPackages.labwc;
      defaultText = literalExpression "pkgs.labwc";
      description = "The package containing /bin/labwc and correct, override-able options to invoke when launching the window manager.";
    };
  };

  config = let
    labwcPackage = cfg.package.override {inherit (cfg) enableXWayland;};
  in
    mkIf cfg.enable {
      desktops.wayland.enable = true;

      environment.systemPackages = with pkgs; [
        labwcPackage
        wlrctl # cool scripting stuff I hear
        swaybg
        rofi-wayland
        wl-clipboard
        wlsunset
        imv
      ];

      security.polkit.enable = true;
      hardware.opengl.enable = mkDefault true;
      fonts.enableDefaultFonts = mkDefault true;
      programs.dconf.enable = mkDefault true;
      # To make a labwc session available if a display manager like SDDM is enabled:
      services.xserver.displayManager.sessionPackages = [labwcPackage];
      programs.xwayland.enable = mkDefault true;
      # For screen sharing (this option only has an effect with xdg.portal.enable):
      xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-wlr];
    };
}
