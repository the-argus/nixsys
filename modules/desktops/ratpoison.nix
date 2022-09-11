{
  lib,
  config,
  pkgs,
  unstable,
  picom,
  ...
}: let
  cfg = config.desktops.ratpoison;
  derivations = {
    picom =
      import ../../packages/picom.nix
      {
        pkgs = unstable;
        inherit picom;
      };
  };
  inherit (lib) mkIf mkEnableOption;
in {
  options.desktops.ratpoison = {
    enable = mkEnableOption "Ratpoison Window Manager";
  };

  config = mkIf cfg.enable {
    desktops.xorg.enable = true;

    services.xserver.windowManager.ratpoison = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      ratpoison.contrib
      rofi
      flameshot
      derivations.picom
    ];
  };
}
