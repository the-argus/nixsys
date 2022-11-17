{lib, config, ...}: let
  inherit (lib) mkOption mkIf;
  cfg = config.gaming;
in {
  options.gaming = {
    enable = mkEnableOption "Install game launchers and setup hardware.";
    minecraft = mkEnableOption "Install a minecraft launcher, pretty much.";
    steam = mkEnableOption "Enable steam and the hardware changes necessary for it."
  };

  config = mkIf cfg.enable {
    hardware.steam-hardware.enable = cfg.steam;
  };
}
