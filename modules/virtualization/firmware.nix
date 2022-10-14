{
  pkgs,
  lib,
  options,
  config,
  username,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.virtualization.firmware;
in {
  options.virtualization.firmware = {
    enable = mkOption {
      description = "Install OVMF firmware for VMs.";
      type = types.bool;
      default = true;
    };
    ovmfPackage = mkOption {
      type = lib.types.package;
      default = pkgs.OVMFFull;
    };
  };
  config = mkIf (cfg.enable && config.virtualization.enable) {
    virtualisation.libvirtd.enable = true;
    # gpu passthrough stuff
    environment.etc = {
      "ovmf/edk2-x86_64-secure-code.fd" = {
        source = config.virtualization.qemuPackage + "/share/qemu/edk2-x86_64-secure-code.fd";
      };
      "ovmf/OVMF_VARS.fd".source = (cfg.ovmfPackage.fd) + /FV/OVMF_VARS.fd;
      "ovmf/OVMF_CODE.fd".source = (cfgovmfPackage.fd) + /FV/OVMF_CODE.fd;
      "ovmf/OVMF.fd".source = (cfg.ovmfPackage.fd) + /FV/OVMF.fd;
    };
  };
}
