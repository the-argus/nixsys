{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.desktops.plasma;
  inherit (lib) mkEnableOption;
in {
  options.desktops.plasma = {
    enable = mkEnableOption "KDE Plasma desktop environment configuration.";
  };

  config = mkIf cfg.enable {};
}
