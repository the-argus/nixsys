{ lib, config, pkgs, ... }:
let
  cfg = config.desktops.sway;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.desktops.sway = {
    enable = mkEnableOption "Sway Window Manager";
  };

  config = mkIf cfg.enable {
    desktops.wayland.enable = true;

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true; # so that gtk works properly
    };

    extraPackages = with pkgs; [
      waybar
      swaybg
      wofi
      wofi-emoji
      wl-clipboard
      wlsunset
      grim
      slurp
    ];
    
    # already done by enabling sway I believe but whatever
    programs.xwayland.enable = true;
  };
}
