{
  lib,
  config,
  pkgs,
  unstable,
  awesome,
  picom,
  ...
}: let
  cfg = config.desktops.awesome;
  derivations = {
    awesome = pkgs.callPackage (import ../../packages).awesome {};
    picom =
      pkgs.callPackage (import ../../packages).picom
      {
        pkgs = unstable;
        inherit picom;
      };
  };
  inherit (lib) mkIf mkEnableOption;
in {
  options.desktops.awesome = {
    enable = mkEnableOption "Awesome Window Manager";
  };

  config = mkIf cfg.enable {
    desktops.xorg.enable = true;

    services.xserver.windowManager.awesome = {
      enable = true;
      package = derivations.awesome;
    };

    environment.systemPackages = with pkgs; [
      rofi
      flameshot
      derivations.picom
    ];
  };
}
