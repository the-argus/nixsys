{
  lib,
  config,
  ...
}: let
  cfg = config.desktops.gnome;
  inherit (lib) mkEnableOption mkIf;
in {
  options.desktops.gnome = {
    enable = mkEnableOption "Gnome desktop environment configuration.";
  };

  config = mkIf cfg.enable {};
}
