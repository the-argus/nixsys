{ pkgs, config, lib, ... }:
let
  cfg = config.virtualization;
  inherit (lib) mkIf mkEnableOption mkOption;
in
{
  options.virtualization = {
    enable = mkEnableOption "Packages for virtualizing other systems.";

    passthrough = {
      enable = mkEnableOption "Single GPU passthrough utilities for my hardware.";
      ovmfPackage = mkOption {
        type = lib.types.package;
        default = pkgs.OVMFFull;
      };
    };

    qemu = {
      package = mkOption {
        type = lib.types.package;
        default = pkgs.qemu_full;
      };
    };
  };

  config = mkIf cfg.enable
    {
      environment.systemPackages = with pkgs; [
        cfg.qemu.package
      ];
    } // mkIf cfg.passthrough.enable {
    # gpu passthrough stuff
    environment.etc = {
      "ovmf/edk2-x86_64-secure-code.fd" = {
        source = cfg.qemu.package + "/share/qemu/edk2-x86_64-secure-code.fd";
      };
      "ovmf/OVMF_VARS.fd".source = cfg.passthrough.ovmfPackage.variables;
      "ovmf/OVMF_CODE.fd".source = cfg.passthrough.ovmfPackage.firmware;
    };
  };
}
