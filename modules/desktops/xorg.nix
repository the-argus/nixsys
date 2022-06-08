{ lib, config, pkgs, picom, ... }:
let
  cfg = config.desktops.xorg;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.desktops.xorg = {
    enable = mkEnableOption "X.org Display Server";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      windowManager.awesome.enable = true;

      libinput.enable = true;
      libinput.touchpad.naturalScrolling = false;
      libinput.touchpad.middleEmulation = true;
      libinput.touchpad.tapping = true;
      libinput.mouse.accelProfile = "flat";

      # use the right picom fork
      services.picom.package = pkgs.picom.overrideAttrs (o: {
        src = picom;
      });

      # disable stuff I don't need
      useGlamor = false;
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
