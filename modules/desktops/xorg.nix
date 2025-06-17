{
  lib,
  config,
  options,
  pkgs,
  ...
}: let
  cfg = config.desktops.xorg;
  inherit (lib) mkIf mkEnableOption;
in {
  options.desktops.xorg = {
    enable = mkEnableOption "X.org Display Server";
  };

  config = mkIf cfg.enable {
    services.libinput = {
      enable = true;
      touchpad.naturalScrolling = false;
      touchpad.middleEmulation = true;
      touchpad.tapping = true;
      mouse.accelProfile = "flat";
    };

    console.useXkbConfig = true;

    services.xserver =
      {
        enable = true;
        xkb.dir = "${pkgs.myPackages.patched_xkeyboardconfig}/etc/X11/xkb";
        exportConfiguration = true;
      }
      // (
        if options.services.xserver ? "excludePackages"
        then {
          excludePackages = with pkgs; [
            xterm
            xorg.xf86inputevdev.out
          ];
        }
        else {}
      );

    environment.systemPackages = with pkgs; [
      feh
      xclip
      xcolor
      ueberzug
      xorg.xauth
      xorg.xf86inputsynaptics
      xorg.xf86inputmouse
    ];
  };
}
