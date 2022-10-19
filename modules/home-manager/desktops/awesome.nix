{
  pkgs,
  lib,
  ...
}: let
  cfg = config.desktops.awesome;
  inherit (lib) mkEnableOption;
in {
  options.desktops.awesome = {
    enable = mkEnableOption "Awesome window manager configuration.";
  };

  config = mkIf cfg.enable {};
}
