{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.services.plymouth = {
    enable = mkEnableOption "Use plymouth";
    playFullAnimation = mkEnableOption "Wait for the boot animation to finish playing before opening login shell.";
    themesPackage = mkOption {
      default = pkgs.callPackage ../packages/plymouth-themes.nix {inherit (cfg) themeName;};
      type = types.package;
    };
    animationName = mkOption {
      type = types.str;
      default = "rings";
    };
  };
}
