{
  lib,
  config,
  ...
}: let
  cfg = config.desktops.ratpoison;
  inherit (lib) mkEnableOption mkIf;
in {
  options.desktops.ratpoison = {
    enable = mkEnableOption "Ratpoison window manager configuration.";
  };

  config = mkIf cfg.enable {};
}
