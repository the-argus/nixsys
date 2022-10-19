{
  pkgs,
  lib,
  ...
}: let
  cfg = config.desktops.ratpoison;
  inherit (lib) mkEnableOption;
in {
  options.desktops.ratpoison = {
    enable = mkEnableOption "Ratpoison window manager configuration.";
  };

  config = mkIf cfg.enable {};
}
