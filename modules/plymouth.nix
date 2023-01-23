{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.services.plymouth;
  inherit (lib) mkEnableOption mkOption mkIf types;
in {
  options.services.plymouth = {
    enable = mkEnableOption "Use plymouth";
    playFullAnimation = mkEnableOption "Wait for the boot animation to finish playing before opening login shell.";
    themesPackage = mkOption {
      default = pkgs.myPackages.plymouth-themes.override {inherit (cfg) themeName;};
      type = types.package;
    };
    themeName = mkOption {
      type = types.str;
      default = "rings";
    };
  };
  config = mkIf cfg.enable {
    boot.plymouth = {
      enable = cfg.enable;
      themePackages = [cfg.themesPackage];
      theme = cfg.themeName;
    };

    systemd.services.plymouth-quit.serviceConfig.ExecStartPre =
      mkIf cfg.playFullAnimation "${pkgs.coreutils-full}/bin/sleep 5";
  };
}
