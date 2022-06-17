{ lib, config, options, pkgs, picom, ... }:
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

      libinput.enable = true;
      libinput.touchpad.naturalScrolling = false;
      libinput.touchpad.middleEmulation = true;
      libinput.touchpad.tapping = true;
      libinput.mouse.accelProfile = "flat";


      # disable stuff I don't need
      useGlamor = false;
    }
    // (if options.services.xserver ? "excludePackages" then
      {
        excludePackages = with pkgs; [
          xterm
          xorg.xf86inputevdev.out
        ];
      }
    else { });

    environment.systemPackages = with pkgs; [
      feh
      xclip
      xorg.xauth
      xorg.xf86inputsynaptics
      xorg.xf86inputmouse
    ];
  };
}
