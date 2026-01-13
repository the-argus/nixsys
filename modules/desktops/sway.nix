{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.desktops.sway;
  inherit (lib) mkIf mkEnableOption;
in {
  options.desktops.sway = {
    enable = mkEnableOption "Sway Window Manager";
    nobar = mkEnableOption "Alternate tiling WM workflow with no status bar.";
  };

  config = mkIf cfg.enable {
    desktops.wayland.enable = true;

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true; # so that gtk works properly
      extraPackages = [];
      extraSessionCommands = ''
        # SDL:
        export SDL_VIDEODRIVER=wayland
        # QT (needs qt5.qtwayland in systemPackages):
        export QT_QPA_PLATFORM=wayland-egl
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      '';
    };

    environment.systemPackages = with pkgs; [
      waybar
      swaybg
      rofi
      wl-clipboard
      wlsunset
      grim
      slurp
      imv
    ];

    xdg.portal.extraPortals = with pkgs; [
      pkgs.xdg-desktop-portal-wlr
    ];

    # already done by enabling sway I believe but whatever
    programs.xwayland.enable = true;
  };
}
