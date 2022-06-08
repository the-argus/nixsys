{ lib, config, pkgs, ... }:
let
  cfg = config.desktops.xorg;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.desktops.xorg = {
    enable = mkEnableOption "X.org Display Server";
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.windowManager.awesome.enable = true;

    # disable stuff I don't need
    services.xserver.useGlamor = false;
    services.xserver = {
      excludePackages = with pkgs; [
        xterm
        xorg.xf86inputevdev.out
      ];
    };

    environment.systemPackages = with pkgs; [
        feh
        xclip
        xorg.xauth
        xorg.xf86inputsynaptics
        xorg.xf86inputmouse
    ];
  };
}
