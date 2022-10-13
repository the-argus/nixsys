{
  pkgs,
  config,
  lib,
  username,
  ...
}: let
  cfg = config.virtualization;
  inherit (lib) mkIf mkEnableOption mkOption;
in {
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
        # containerization
        users.users.${username}.extraGroups = ["docker"];
        users.extraUsers.${username} = {
          subUidRanges = [
            {
              startUid = 100000;
              count = 65536;
            }
          ];
          subGidRanges = [
            {
              startGid = 100000;
              count = 65536;
            }
          ];
        };
        virtualisation = {
          docker = {
            enable = true;
          };
          podman = {
            enable = true;

            # Required for containers under podman-compose to be able to talk to each other.
            defaultNetwork.dnsname.enable = true;

            extraPackages = [pkgs.podman-compose];
          };
        };

        environment.systemPackages =
          [
            cfg.qemu.package
          ]
          ++ (mkIf cfg.passthrough.enable [
            # pkgs.libvirt
          ]);
      }
      // (mkIf cfg.passthrough.enable {
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
      }));
}
