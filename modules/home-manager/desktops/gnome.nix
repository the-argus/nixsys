{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.desktops.gnome;
  inherit (lib) mkEnableOption;
in {
  options.desktops.gnome = {
    enable = mkEnableOption "Gnome desktop environment configuration.";
  };

  config = mkIf cfg.enable {};
}
