{ lib, config, pkgs, awesome, picom, ... }:
let
  cfg = config.desktops.awesome;
  packages = import ../../packages;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.desktops.awesome = {
    enable = mkEnableOption "Awesome Window Manager";
  };

  config = mkIf cfg.enable {
    desktops.xorg.enable = true;

    windowManager.awesome = {
      enable = true;
      package = packages.awesome { inherit pkgs; inherit awesome; };
    };

    environment.systemPackages = with pkgs; [
      rofi
      flameshot
      packages.picom {inherit pkgs; inherit picom;}
    ];
  };
}
