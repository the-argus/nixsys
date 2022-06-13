{ lib, config, pkgs, picom, ... }:
let
  cfg = config.desktops.qtile;
  derivations = {
    picom = import ../../packages/picom.nix
        { inherit pkgs; inherit picom;}; 
  };
  inherit (lib) mkIf mkEnableOption;
in
{
  options.desktops.qtile = {
    enable = mkEnableOption "Qtile Window Manager";
  };

  config = mkIf cfg.enable {
    desktops.xorg.enable = true;

    services.xserver.windowManager.qtile = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      alacritty
      xsuspender
      xmousepasteblock
      xfce.xfce4-clipman-plugin
      dunst
      rofi
      flameshot
      derivations.picom
    ];
  };
}
