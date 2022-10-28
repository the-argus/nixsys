{
  lib,
  config,
  ...
}: let
  cfg = config.desktops.awesome;
  inherit (lib) mkEnableOption mkIf;
in {
  options.desktops.awesome = {
    enable = mkEnableOption "Awesome window manager configuration.";
  };

  config = mkIf cfg.enable {};
}
