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
    packages.awesome.enable = true;

    windowManager.awesome = {
      enable = true;
      package = packages.awesome.package;
    };

    environment.systemPackages = [
      packages.picom.package
    ];

    environment.systemPackages = with pkgs; [
      rofi
      flameshot
    ];
  };
}
