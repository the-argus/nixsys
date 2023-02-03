{
  config,
  lib,
  pkgs,
  modulesPath,
  settings,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  nix.settings.system-features =
    ["nixos-test" "benchmark" "big-parallel" "kvm"]
    ++ settings.features;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/NIXHOME";
    fsType = "btrfs";
  };

  fileSystems."/efi" = {
    device = "/dev/disk/by-label/WINBOOT";
    fsType = "vfat";
  };

  swapDevices = [{device = "/dev/disk/by-label/SWAP";}];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
