{ lib, config, pkgs, ... }:
let
  cfg = config.desktops.awesome;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.desktops.awesome = {
    enable = mkEnableOption "Awesome Window Manager";
  };

  config = mkIf cfg.enable {
    desktops.xorg.enable = true;
    packages.picom.enable = true;

    environment.systemPackages = with pkgs; [
        rofi
        flameshot
    ];
  };
}
