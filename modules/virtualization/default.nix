{
  pkgs,
  config,
  lib,
  username,
  ...
}: let
  cfg = config.virtualization;
  inherit (lib) mkIf mkEnableOption mkOption types;
in {
  imports = [./containers.nix];

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
        default = pkgs.qemu;
      };
    };
  };

  config =
    mkIf cfg.enable
    ({
        environment.systemPackages =
          [
            cfg.qemu.package
          ]
          ++ (mkIf cfg.passthrough.enable [
            # pkgs.libvirt
          ]);
      }
      // (
        if cfg.passthrough.enable
        then {
          virtualisation.libvirtd.enable = true;
          # gpu passthrough stuff
          environment.etc = {
            "ovmf/edk2-x86_64-secure-code.fd" = {
              source = cfg.qemu.package + "/share/qemu/edk2-x86_64-secure-code.fd";
            };
            "ovmf/OVMF_VARS.fd".source = (cfg.passthrough.ovmfPackage.fd) + /FV/OVMF_VARS.fd;
            "ovmf/OVMF_CODE.fd".source = (cfg.passthrough.ovmfPackage.fd) + /FV/OVMF_CODE.fd;
            "ovmf/OVMF.fd".source = (cfg.passthrough.ovmfPackage.fd) + /FV/OVMF.fd;
          };
        }
        else {}
      ));
}
