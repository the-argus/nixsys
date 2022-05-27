{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/444dd843-a3b1-4e59-9d47-c62cfab94d8b";
      fsType = "ext4";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/3b8082af-c41c-4b45-b4f4-5ece2a003373";
      fsType = "btrfs";
    };

  fileSystems."/efi" =
    { device = "/dev/disk/by-uuid/F230-06EA";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/0d554a74-2d3c-4bd4-a5db-1fc7062485f9"; }
    ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
