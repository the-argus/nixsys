{lib, ...}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.services.plymouth = {
    enable = mkEnableOption "Use plymouth";
    playFullAnimation = mkEnableOption "Wait for the boot animation to finish playing before opening login shell.";
    animationName = mkOption {
      type = types.string;
      default = "rings";
    };
  };
}
