{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.desktops.awesome;
  derivations = {
    inherit (pkgs.myPackages) picom awesome;
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
