{ lib, config, pkgs, ... }:
let
  cfg = config.desktops.awesome;
  inherit (lib) mkIf mkEnableOption;
in
{
  imports = [
    ../packages/picom.nix
  ];

  options.desktops.awesome = {
    enable = mkEnableOption "Awesome Window Manager";
  };

  config = mkIf cfg.enable {
    desktops.xorg.enable = true;
    
    # installs custom picom fork
    packages.picom.enable = true;

    environment.systemPackages = with pkgs; [
      rofi
      flameshot
    ];
  };
}
