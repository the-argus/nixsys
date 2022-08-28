{ lib, config, pkgs, picom, unstable, ... }:
let
  cfg = config.desktops.qtile;
  derivations = {
    picom = import ../../packages/picom.nix
        { pkgs = unstable; inherit picom;}; 
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
      xmousepasteblock
      python310Packages.psutil # cpu widget
      xfce.xfce4-clipman-plugin
      dunst
      rofi
      flameshot
      derivations.picom

      libnotify # notify-send scripts
    ];
  };
}
