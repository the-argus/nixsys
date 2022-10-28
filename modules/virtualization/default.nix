{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.virtualization;
  inherit (lib) mkIf mkEnableOption mkOption types;
in {
  imports = [./containers ./firmware.nix];

  options.virtualization = {
    enable = mkEnableOption "Packages for virtualizing other systems.";

    qemuPackage = mkOption {
      type = lib.types.package;
      default = pkgs.qemu;
    };
  };

  config =
    mkIf cfg.enable
    {
      environment.systemPackages = [
        cfg.qemuPackage
      ];
    };
}
