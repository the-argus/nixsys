{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.gaming;
in {
  options.gaming = {
    enable = mkEnableOption "Install game launchers and setup hardware.";
    minecraft = mkEnableOption "Install a minecraft launcher, pretty much.";
    steam = mkEnableOption "Enable steam and the hardware changes necessary for it.";
  };

  config = mkIf (cfg.enable && !config.system.minimal) {
    hardware.steam-hardware.enable = cfg.steam;
  };
}
